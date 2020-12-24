local npcManager = require("npcManager")

local walker = {}


walker.idList = {}
walker.idMap  = {}

function walker.register(npcID)
    npcManager.registerEvent(npcID, walker, "onTickNPC")
end


function walker.onTickNPC(v)
    if Defines.levelFreeze then return end

    if v.despawnTimer <= 0 then
        return
    end

    if v.forcedState ~= 0 or v.projectile or v.grabbingPlayer ~= nil then
        return
    end

    v.speedX = 1.2 * v.direction
end


return walker