local npcManager = require("npcManager")

local walkerAI = require("npcs/ai/walker")


local goomba = {}
local npcID = NPC_ID

local deathEffectID = 4
local stompedEffectID = 2


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
    },
    {
        [HARM_TYPE_JUMP]            = stompedEffectID,
        [HARM_TYPE_FROMBELOW]       = deathEffectID,
        [HARM_TYPE_NPC]             = deathEffectID,
        [HARM_TYPE_PROJECTILE_USED] = deathEffectID,
        [HARM_TYPE_LAVA]            = npcManager.defaultDeathEffects[HARM_TYPE_LAVA],
        [HARM_TYPE_HELD]            = deathEffectID,
        [HARM_TYPE_TAIL]            = deathEffectID,
        [HARM_TYPE_SPINJUMP]        = npcManager.defaultDeathEffects[HARM_TYPE_SPINJUMP],
        [HARM_TYPE_SWORD]           = npcManager.defaultDeathEffects[HARM_TYPE_SWORD],
    }
)


walkerAI.register(npcID)

return goomba