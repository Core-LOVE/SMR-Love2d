local npc = {}
local npcManager = require("npcManager")

function npc.onInitAPI()
	npcManager.registerSpecialEvent(NPC_ID, npc, "onActiveNPC")
end

function npc.onActiveNPC(v)	
	v.ai2 = v.ai2 - (0.0483321947 * v.spawnDirection)
	
	v.speedX = (math.cos(v.ai2) * v.spawnAi1 * v.width * 0.0483321947) * v.spawnDirection
	v.speedY = (math.sin(v.ai2) * v.spawnAi1 * v.height * 0.0483321947) * v.spawnDirection
end

return npc