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
            -- Get each property
            local output = ""
            local startPoint = 1

            while true do
                local start,ending = line:find(".+:[^;]+;",startPoint,false)
                
                if start ~= nil and ending ~= nil and ending <= #line then
                    local colon = line:sub(start,ending):find(":",1,true)
                    local property = line:sub(start,colon-1)
                    local value = line:sub(colon+1,ending-1)

                    output = output.. property.. " = ".. value.. ", "

                    startPoint = ending
                else
                    break
                end
            end

            print(output)

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