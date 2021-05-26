local txt_parser = require("txt_parser")

local npcConfig = {}


local function getGFXWidth(configObj,key)
    local value = configObj._propertyValues.gfxwidth
    if value == nil or value == 0 then
        return configObj.width
    else
        return value
    end
end
local function getGFXHeight(configObj,key)
    local value = configObj._propertyValues.gfxheight
    if value == nil or value == 0 then
        return configObj.height
    else
        return value
    end
end


local function getWithEmptyTableDefault(configObj,key)
    local value = configObj._propertyValues[key]
    if value ~= nil then
        return value
    end

    return {}
end


local harmTypesList = {
    HARM_TYPE_JUMP,
	HARM_TYPE_FROMBELOW,
	HARM_TYPE_NPC,
	HARM_TYPE_PROJECTILE_USED,
	HARM_TYPE_LAVA,
	HARM_TYPE_HELD,
	HARM_TYPE_TAIL,
	HARM_TYPE_SPINJUMP,
	HARM_TYPE_VANISH,
	HARM_TYPE_SWORD,
}

local function getVulnerableHarmTypes(configObj,key)
    local ret = {}

    for _,harmTypeID in ipairs(harmTypesList) do
        local damage = configObj.damageMap[harmTypeID]

        if damage ~= nil and damage > 0 then
            table.insert(ret,damage)
        end
    end

    return ret
end

local function setVulnerableHarmTypes(configObj,key,value)
    config.damageMap = {}

    for _,harmTypeID in ipairs(value) do
        config.damageMap[harmTypeID] = 1
    end
end



local properties = {
    width             = {default = 32},
    height            = {default = 32},
    gfxwidth          = {get = getGFXWidth},
    gfxheight         = {get = getGFXHeight},
    gfxoffsetx        = {default = 0},
    gfxoffsety        = {default = 2},
    frames            = {default = 2},
    framespeed        = {default = 8},
    framestyle        = {default = 0},

    speed             = {default = 1},
    score             = {default = 2},

    playerblock       = {default = false},
    playerblocktop    = {default = false},
    npcblock          = {default = false},
    npcblocktop       = {default = false},
    
    grabside          = {default = false},
    grabtop           = {default = false},
    jumphurt          = {default = false},
    nohurt            = {default = false},
    nogravity         = {default = false},
    noblockcollision  = {default = false},
    cliffturn         = {default = false},
    noyoshi           = {default = false},
    foreground        = {default = false}, -- mostly deprecated, in favour of priority
    priority          = {default = nil},
    nofireball        = {default = false},
    noiceball         = {default = false},

    harmlessgrab      = {default = false},
    harmlessthrown    = {default = false},
    spinjumpsafe      = {default = false},

    -- TODO: make this all just read from AI files
    isshell           = {default = false},
    isinteractable    = {default = false},
    iscoin            = {default = false},
    isvine            = {default = false},
    isplant           = {default = false},
    iscollectablegoal = {default = false},
    isflying          = {default = false},
    iswaternpc        = {default = false},
    isshoe            = {default = false},
    isyoshi           = {default = false},
    isbot             = {default = false},
    isvegetable       = {default = false},
    iswalker          = {default = false},
    ismushroom        = {default = false},
    
    gravity           = {default = Defines.npc_grav},
    maxgravity        = {default = 8},

    health            = {default = 1},


    damagemap = {get = getWithEmptyTableDefault},
    effectmap = {get = getWithEmptyTableDefault},

    vulnerableharmtypes = {get = getVulnerableHarmTypes,set = setVulnerableHarmTypes},
}


local internalConfigs = {}


local configObjMT = {}

function configObjMT.__index(self, key)
    key = key:lower()

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

function configObjMT.__newindex(self, key, value)
    key = key:lower()

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


local libraryMT = {}
setmetatable(npcConfig,libraryMT)

function libraryMT.__index(_, key)
    if type(key) == "number" and key >= 1 and key <= NPC_MAX_ID and math.floor(key) == key then
        internalConfigs[key] = internalConfigs[key] or setmetatable({
            id = key,
            _propertyValues = {},
        },configObjMT)

        return internalConfigs[key]
    end

    return nil
end


function npcConfig.load()
    for id = 1, NPC_MAX_ID do
        local path = "config/npc/npc-".. id.. ".txt"

        if love.filesystem.getInfo(path) then
            local parsed = txt_parser.load(path)
            
            for k,v in pairs(parsed) do
                npcConfig[id][k] = v
            end
        end
    end
end

function npcConfig.addGlobalProperty(name, settings)
    properties[name] = settings
end

local ncMt = {
	__index = function(t, id)
        local path = "config/npc/npc-".. id.. ".txt"

        if love.filesystem.getInfo(path) then
			 local parsed = txt_parser.load(path)
			 
            for k,v in pairs(parsed) do
                t[id][k] = v
            end
		end
		
		return t[id]
	end
}


return npcConfig