local npcManager = require("npcManager")

local walker = require("npcs/ai/walker")


local goomba = {}
local npcID = NPC_ID


local goombaSettings = {
    id = npcID,
}


npcManager.setNpcSettings(goombaSettings)
npcManager.registerHarmTypes(npcID,
    {
        [HARM_TYPE_JUMP] = true,
    }
)


walker.register(npcID)

return goomba