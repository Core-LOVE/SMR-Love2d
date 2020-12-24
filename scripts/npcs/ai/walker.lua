local npcManager = require("npcManager")

local walker = {}


walker.idList = {}
walker.idMap  = {}

function walker.register(npcID)
    npcManager.registerSpecialEvent(npcID, walker, "onActiveNPC")
end


function walker.onActiveNPC(v)
    if v.forcedState ~= 0 or v.projectile or v.grabbingPlayer ~= nil then
        return
    end

    v.speedX = 1.2 * v.direction
end


return walker