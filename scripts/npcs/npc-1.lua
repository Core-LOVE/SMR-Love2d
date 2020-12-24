local npcManager = require("npcManager")

local walkerAI = require("npcs/ai/walker")


local goomba = {}
local npcID = NPC_ID


local goombaSettings = {
    id = npcID,
}


npcManager.setNpcSettings(goombaSettings)
npcManager.registerHarmTypes(npcID,
    {
        [HARM_TYPE_JUMP]            = true,
        [HARM_TYPE_FROMBELOW]       = true,
        [HARM_TYPE_NPC]             = true,
        [HARM_TYPE_PROJECTILE_USED] = true,
        [HARM_TYPE_LAVA]            = true,
        [HARM_TYPE_HELD]            = true,
        [HARM_TYPE_TAIL]            = true,
        [HARM_TYPE_SPINJUMP]        = true,
        [HARM_TYPE_VANISH]          = true,
        [HARM_TYPE_SWORD]           = true,
    }
)


walkerAI.register(npcID)

return goomba