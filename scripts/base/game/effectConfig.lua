local ini_parser = require("ini_parser")

local effectConfig = {}


local priorityEnums = {
    BACKGROUND = -60,
    FOREGROUND = -5,
}
local alignEnums = {
    LEFT = 0,
    RIGHT = 1,
    BOTTOM = 1,
    TOP = 0,
    CENTRE = 0.5,
    MID = 0.5,
    CENTER = 0.5,
    MIDDLE = 0.5,
}


local function getWidth(configObj,key)
    if configObj._propertyValues[key] == nil then
        return Graphics.sprites.effect[configObj.id].img:getWidth()
    else
        return configObj._propertyValues[key]
    end
end

local framestyleEffect = {[0] = 1,[1] = 2,[2] = 4}
local function getHeight(configObj,key)
    if configObj._propertyValues[key] == nil then
        return Graphics.sprites.effect[configObj.id].img:getHeight() / (configObj.frames * framestyleEffect[configObj.framestyle]) / configObj.variants
    else
        return configObj._propertyValues[key]
    end
end


local properties = {
    spawnID        = {default = nil},

    delay          = {default = 0},
    sound          = {default = nil},
    priority       = {default = priorityEnums.FOREGROUND,enums = priorityEnums},

    lifetime       = {default = 65},

    frames         = {default = 1},
    framespeed     = {default = 8},
    framestyle     = {default = 0},
    animationFrame = {default = 0},
    animationTimer = {default = 0},

    xAlign         = {default = alignEnums.MID,enums = alignEnums},
    yAlign         = {default = alignEnums.MID,enums = alignEnums},

    xOffset        = {default = 0},
    yOffset        = {default = 0},

    speedX         = {default = 0},
    speedY         = {default = 0},
    maxSpeedX      = {default = -1},
    maxSpeedY      = {default = -1},
    accelerationX  = {default = 0},
    accelerationY  = {default = 0},
    gravity        = {default = 0},

    direction      = {default = -1},
    opacity        = {default = 1},

    angle          = {default = 0},
    rotation       = {default = 0},

    variants       = {default = 1},
    variant        = {default = 1},


    width          = {get = getWidth },
    height         = {get = getHeight},


    onInit         = {},
    onTick         = {},
    onDeath        = {},
}

local propertiesList = {}
for name,_ in pairs(properties) do
    table.insert(propertiesList,name)
end


local effectObjConfigMT = {}

function effectObjConfigMT.__index(self, key)
    local property = properties[key]

    if property ~= nil and property.get ~= nil then
        return property.get(self, key)
    end

    if self._propertyValues[key] ~= nil then
        return self._propertyValues[key]
    end

    if property ~= nil and property.default ~= nil then
        return property.default
    end

    return nil
end

function effectObjConfigMT.__newindex(self, key, value)
    local property = properties[key]

    if property ~= nil and property.set ~= nil then
        property.set(self, key, value)
        return
    end

    if value ~= property.default then
        self._propertyValues[key] = value
    else
        self._propertyValues[key] = nil
    end
end


local function getValue(parsed,parsedObj,objConfig,name)
    local value = parsedObj[name]
    if value ~= nil then
        return value
    end

    if parsedObj.template ~= nil then
        value = parsed[parsedObj.template][name]
        if value ~= nil then
            return value
        end
    end

    if parsedObj.import ~= nil then
        value = effectConfig.defaults[parsedObj.import][name]
        if value ~= nil then
            return value
        end
    end

    return nil
end

local function convertParsedIntoConfig(id,parsed)
    parsed[1] = parsed[1] or parsed.first or nil

    local config = {id = id}

    for iteration,parsedObj in ipairs(parsed) do
        local objConfig = setmetatable({
            _propertyValues = {},
            id = id,
        },effectObjConfigMT)

        
        for _,name in ipairs(propertiesList) do
            local property = properties[name]

            objConfig[name] = getValue(parsed,parsedObj,objConfig,name)

            if property.enums ~= nil then
                objConfig[name] = property.enums[objConfig[name]] or objConfig[name]
            end

            if objConfig._propertyValues[name] == property.default then
                objConfig._propertyValues[name] = nil
            end
        end

        config[iteration] = objConfig
    end

    return config
end


function effectConfig.load()
    for id = 1, EFFECT_MAX_ID do
        local path = "config/effect/effect-".. id.. ".txt"

        if love.filesystem.getInfo(path) then
            Effect.config[id] = convertParsedIntoConfig(id,ini_parser.load(path))
        end
		
		print("config/effect/effect-".. id.. ".txt is loaded!")
    end
end


-- Defaults and stuff
do
    effectConfig.onTick = {}
    effectConfig.onInit = {}
    effectConfig.onDeath = {}

    effectConfig.defaults = {}


    -- Init events
    function effectConfig.onInit.INIT_ARC(v)
        if v.parent.speedX == 0 then
            v.speedX = love.math.random(-1,1)
            v.speedX = v.speedX + math.sign(v.speedX)*0.5
        else
            v.speedX = -v.parent.speedX
        end
    end


    -- Tick events
    function effectConfig.onTick.TICK_SINGLE(v)
        if (v.lifetime-v.timer) > (v.frames*v.framespeed) then
            v.timer = 0
        end
    end


    -- Defaults
    effectConfig.defaults.AI_STOMPED = {
        lifetime = 20,
    }

    effectConfig.defaults.AI_SINGLE = {
        onTick = "TICK_SINGLE",
        lifetime = 10000,
    }

    effectConfig.defaults.AI_ARC = {
        onInit = "INIT_ARC",
        lifetime = 500,
        gravity = 0.5,
        maxSpeedY = 10,
        speedY = -11,
    }

    effectConfig.defaults.AI_DROP = {
        lifetime = 500,
        gravity = 0.5,
        maxSpeedY = 10,
    }
	
	effectConfig.defaults.AI_PLAYER = {
		
	}
end


return effectConfig