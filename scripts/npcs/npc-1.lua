local npcManager = require("npcManager")

local walker = require("npcs/ai/walker")


local goomba = {}
local npcID = NPC_ID


local goombaSettings = {
    id = npcID,
}


npcManager.setNpcSettings(goombaSettings)


walker.register(npcID)

return goomba