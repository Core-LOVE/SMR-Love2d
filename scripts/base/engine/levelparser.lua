local levelParser = {}


local filesystem = love.filesystem


local formats = {}


local function parsingAssert(condition,err,path)
    assert(condition,"Could not load level '".. path.. "': ".. err)
end
local function parsingWarn(warning)
    print("LEVEL PARRSING WARNING: ".. warning)
end



-- lvlx parsing
do
    local types = {
        HEAD = {},

        SECTION = {},
        STARTPOINT = {},

        BLOCK = {},
        NPC = {},
		BGO = {},
		
		PHYSICS = {},
		DOORS = {},
		
        LAYERS = {},
        EVENTS_CLASSIC = {},
    }

    -- Setup types
	types.DOORS.spawn = (function(properties)
		local v = Warp.create(properties.DT, properties.IX, properties.IY, properties.OX, properties.OY)
		v.entranceDirection = properties.ID or 1
		v.exitDirection = properties.OD or 1
		
		if properties.TW == 1 then
			local v2 = Warp.create(properties.DT, properties.OX, properties.OY, properties.IX, properties.IY)
			v2.entranceDirection = properties.OD or 1
			v2.exitDirection = properties.ID or 1
		end
	end)
	
	types.SECTION.spawn = (function(properties)
		local boundary = {
			left = properties.L,
			right = properties.R,
			top = properties.T,
			bottom = properties.B
		}
		
		local v = Section.create(properties.SC + 1, boundary, properties.MZ, properties.MF, properties.BG)
	end)
	
    types.BLOCK.spawn = (function(properties)
        local v = Block.spawn(properties.ID,properties.X,properties.Y)

        v.width  = properties.W or v.width
        v.height = properties.H or v.height

        if properties.CN ~= nil then
            v.contentID = properties.CN
            
            if v.contentID < 0 then -- Coins
                v.contentID = -v.contentID
            elseif v.contentID > 0 then -- NPC's
                v.contentID = v.contentID+1000
            end
        end

        v.hiddenUntilHit = properties.IV or false
        v.slippery = properties.SL or false
    end)

	types.BGO.spawn = (function(properties)
		local v = BGO.spawn(properties.ID, properties.X, properties.Y)
		
		v.zOffset = properties.ZO or 0
	end)
	
	types.NPC.spawn = (function(properties)
        local v = NPC.spawn(properties.ID, properties.X, properties.Y)
        
        v.despawnTimer = 2
		
		v.direction = properties.D or 0
		v.spawnDirection = properties.D or 0
		if v.direction == 0 then
			local t = {
			[1] = -1,
			[2] = 1
			}
			v.direction = t[math.floor(math.random(1,2))]
		end
        
        v.legacyBoss = properties.BS or false
        v.dontMove = properties.NM or false
        v.friendly = properties.FD or false
		v.spawnAi1 = properties.S1 or 0
		v.spawnAi2 = properties.S2 or 0
		
		v.msg = properties.MG or ""
	end)
	
	types.LAYERS.spawn = (function(properties)
		local v = Layer.create(properties.LR, properties.HD or false)
    end)
    
    types.STARTPOINT.spawn = (function(properties)
        -- TODO: make this create a start point rather than a player
        -- if #Player > 0 then return end

		local v = Player.spawn(1, properties.X, properties.Y)
		v.direction = properties.D
    end)
    
    types.PHYSICS.spawn = (function(properties)
		local v = Liquid.create(properties.ET + 1, properties.X, properties.Y, properties.W, properties.H)
    end)
    


    -- hi core please keep a gap here 🐱

    local stringEscapeCharacters = {
        ["n"] = "\n",
        ["\""] = "\"",
        ["\\"] = "\\",
        [";"] = ";",
        [":"] = ":",
        ["["] = "[",
        ["]"] = "]",
        [","] = ",",
        ["%"] = "%",
    }

    local function parseValue(path,line,valueStart)
        if line:sub(valueStart,valueStart) == "\"" then -- strings are special due to escape characters
            local value = ""
            local valueEnd = valueStart+1

            local i = valueStart+1
            while true do
                parsingAssert(i <= #line,"Unclosed string at line '".. line.. "'",path)

                local here = line:sub(i,i)

                if here == "\"" then -- end of string
                    valueEnd = i+1
                    break
                elseif here == "\\" then -- escape characters
                    local next = line:sub(i+1,i+1)
                    local nextEscape = stringEscapeCharacters[next]

                    parsingAssert(nextEscape ~= nil,"Invalid escape sequence '\\".. next.. "' at line '".. line.. "'",path)

                    value = value.. nextEscape

                    i = i + 1 + #nextEscape
                else
                    value = value.. here
                    i = i + 1
                end
            end

            return value,valueEnd
        end

        local valueEnd = line:find(";",valueStart) -- the end of the value is just the first semicolon for most values
        parsingAssert(valueEnd ~= nil,"Line '".. line.. "' is unclosed",path)



        local value = line:sub(valueStart,valueEnd-1)

        -- Convert
        local number = tonumber(value)

        if number ~= nil then
            value = number
        end


        return value,valueEnd
    end

    local function parseObject(parsingData,path,line)
        local obj = {}

        local pos = 1
        while (pos < #line) do
            local remaining = line:sub(pos)

            -- Search for the property name
            local nameStart,nameEnd = remaining:find("^[^;:]+:")
            if nameStart == nil or nameEnd == nil then
                break
            end

            -- Parse and insert
            local name = remaining:sub(nameStart,nameEnd-1)
            local value,valueEnd = parseValue(path,line,pos+nameEnd)

            obj[name] = value

            -- Prepare for next run
            pos = valueEnd+1
        end

        return obj
    end

    local function parseLine(parsingData,path,line)
        -- Check if this is an ending
        if parsingData.currentTypeName ~= nil and line == (parsingData.currentTypeName.. "_END") then
            --print(parsingData.currentTypeName.. " ended")

            parsingData.currentTypeData = nil
            parsingData.currentTypeName = nil

            return
        else
            local endingType = line:find("^(.+)_END$")
            
            parsingAssert(endingType == nil or types[endingType] == nil,"Cannot end type '".. tostring(endingType).. "' with current type ".. ''.. tostring(parsingData.currentTypeName).. "'.",path)
        end


        -- Parse an object. Each line is an object.
        if parsingData.currentTypeName ~= nil then
            local obj = parseObject(parsingData,path,line)

            --print(inspect(obj))

            if parsingData.currentTypeData.spawn ~= nil then
                parsingData.currentTypeData.spawn(obj)
            end

            return
        end


        -- Check if this is the start of a type
        local thisTypeData = types[line]
        if thisTypeData ~= nil then
            parsingData.currentTypeName = line
            parsingData.currentTypeData = thisTypeData

            --print(line.. " started")

            return
        elseif currentTypeData == nil then
            parsingWarn(line.. " is not a recognised type")
            return
        end
    end

    local function loadLevel(path)
        local parsingData = {}

        parsingData.path = path
        parsingData.currentTypeName = nil
        parsingData.currentTypeData = nil

        for line in love.filesystem.lines(path) do
            parseLine(parsingData,path,line)
        end
    end

    formats.lvlx = loadLevel
end

function levelParser.load(path, dat)
	isOverworld = false
	
    local data
	
	if path ~= nil then
		data = love.filesystem.read(path)
	end
	
    parsingAssert(data ~= nil,"Could not find file",path)
	
	if dat ~= nil then
		data = dat
	end
	
    local format = path:match("^.*%.(.+)$")
    local formatLoad = formats[format]
	
    parsingAssert(formatLoad ~= nil,"Unknown level format",path)
	
    formatLoad(path)
	
	LevelPath = string.gsub(path, ".lvlx", "")
	if love.filesystem.getInfo(LevelPath.."/luna.lua") then
		LevelScript = require(LevelPath.."/luna")
		onStart()
	end
end

return levelParser