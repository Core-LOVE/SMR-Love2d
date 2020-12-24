local npcManager = {}


function npcManager.setNpcSettings(settings)
    assert(settings.id ~= nil,"NPC settings must contain 'id' field.",2)

    local config = NPC.config[settings.id]

    for key,value in pairs(settings) do
        if key ~= "id" then
            config[key] = value
        end
    end

    return config
end

function npcManager.getNpcSettings(id)
    return NPC.config[id]
end


npcManager.eventListeners = {[true] = {},[false] = {}}
npcManager.registeredEvents = {[true] = {},[false] = {}}


local function tryCalledEvent(npc,isEarly,eventName,...)
    local objs = npcManager.eventListeners[isEarly][eventName]
    if objs == nil then
        return
    end

    objs = objs[npc.id]
    if objs == nil then
        return
    end

    
    for _,obj in ipairs(objs) do
        local library = obj[1]
        local functionName = obj[2] or eventName

        local func = library[functionName]

        if func ~= nil then
            func(npc,...)
        end
    end
end

function npcManager.registerEvent(id, library, eventName, functionName, isEarly)
    if isEarly == nil then
        isEarly = true
    end

    if npcManager.eventListeners[isEarly][eventName] == nil then
        local normalEventName = eventName:match("^(.+)NPC$")


        npcManager.eventListeners[isEarly][eventName] = {}

        npcManager.registeredEvents[isEarly][eventName] = (function(...)
            -- Call events
            for _,npc in NPC.iterate() do
                tryCalledEvent(npc,isEarly,eventName,...)
            end
        end)

        registerEvent(npcManager.registeredEvents[isEarly],normalEventName,eventName,isEarly)
    end


    npcManager.eventListeners[isEarly][eventName]     = npcManager.eventListeners[isEarly][eventName]     or {}
    npcManager.eventListeners[isEarly][eventName][id] = npcManager.eventListeners[isEarly][eventName][id] or {}

    table.insert(npcManager.eventListeners[isEarly][eventName][id], {library,functionName})
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

npcManager.defaultDeathEffects = {
    [HARM_TYPE_LAVA] = 13,
    [HARM_TYPE_SPINJUMP] = 10,
    [HARM_TYPE_SWORD] = 63,
}

function npcManager.registerHarmTypes(id, damageMap, effectMap)
    local config = NPC.config[id]


    config.damageMap = {}

    for _,harmTypeID in ipairs(harmTypesList) do
        local damage = damageMap[harmTypeID]

        if damage == true then
            damage = 1
        elseif damage == false or damage == 0 then
            damage = nil
        end

        config.damageMap[harmTypeID] = damage
    end

    if type(effectMap) == "number" then
        config.effectMap = {}

        for _,harmTypeID in ipairs(harmTypesList) do
            if harmTypeID ~= HARM_TYPE_VANISH then
                config.effectMap[harmTypeID] = npcManager.defaultDeathEffects[harmTypeID] or effectMap
            end
        end
    elseif effectMap ~= nil then
        config.effectMap = effectMap
    else
        config.effectMap = {}
    end
end


return npcManager