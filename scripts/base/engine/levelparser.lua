local levelParser = {}


local filesystem = love.filesystem


local formats = {}


local function parsingAssert(condition,err,path)
    assert(condition,"Could not load level '".. path.. ": ".. err)
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

        LAYERS = {},
        EVENTS_CLASSIC = {},
    }


    local function parseValue(path,line,valueStart)
        --[[if line:sub(valueStart,valueStart) == "\"" then -- strings are special due to escape characters

        end]]

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
            print(parsingData.currentTypeName.. " ended")

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

            print(inspect(obj))

            return
        end


        -- Check if this is the start of a type
        local thisTypeData = types[line]
        if thisTypeData ~= nil then
            parsingData.currentTypeName = line
            parsingData.currentTypeData = thisTypeData

            print(line.. " started")

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


function levelParser.load(path)
    local data = love.filesystem.read(path)
    parsingAssert(data ~= nil,"Could not find file",path)

    local format = path:match("^.*%.(.+)$")
    local formatLoad = formats[format]

    parsingAssert(formatLoad ~= nil,"Unknown level format",path)

    formatLoad(path)
end

return levelParser