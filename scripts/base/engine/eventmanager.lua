local EventManager = {}


EventManager.eventsList = {
    "onTick","onTickEnd",
    "onDraw","onDrawEnd",
	
    "onNPCHarm","onPostNPCHarm",
    "onNPCKill","onPostNPCKill",
	
	"onBlockHit", "onPostBlockHit",
	"onBlockDestroyed", "onPostBlockDestroyed",
	
	"onPause", "onUnpause",
}


EventManager.listeners = {[true] = {},[false] = {}}


function EventManager.callListeners(eventName,isEarly,...)
    local objs = EventManager.listeners[isEarly][eventName]

    if objs ~= nil then
        for _,obj in ipairs(objs) do
            local library = obj[1]
            local functionName = obj[2] or eventName

            local func = library[functionName]

            if func ~= nil then
                func(...)
            end
        end
    end
end


function EventManager.callEvent(eventName,...)
    EventManager.callListeners(eventName, true, ...)
    EventManager.callListeners(eventName, false, ...)

    --print(eventName.. " run.")
end

function registerEvent(library,eventName,functionName,isEarly)
    if isEarly == nil then
        isEarly = true
    end

    EventManager.listeners[isEarly][eventName] = EventManager.listeners[isEarly][eventName] or {}

    table.insert(EventManager.listeners[isEarly][eventName], {library,functionName})
end


-- Overwrite require to add onInitAPI, and allow more paths
do
    local type = (rawtype or type)

    local normalRequire = require

    rawrequire = normalRequire

    local function tryPath(path)
		if love.filesystem.getInfo(path .. '.lua') then
			return path
		end
    end


    local requireCache = {}

    function require(name)
        if requireCache[name] ~= nil then
            return requireCache[name]
        end

        -- TODO: update this to include levels and episodes
        local path = tryPath(name) or tryPath("scripts/base/".. name) or tryPath("scripts/".. name)
        assert(path ~= nil,"Module '".. name.. "' not found.")


        local library = normalRequire(path)

        if library ~= nil and type(library) == "table" and type(library.onInitAPI) == 'function' then
            library.onInitAPI()
        end

        requireCache[name] = library


        print("Module '".. name.. "' successfully loaded. (Path: ".. path.. ".lua)")

        return library
    end
end


return EventManager