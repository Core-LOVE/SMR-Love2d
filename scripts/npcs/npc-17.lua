local npc = {}

do
	local npcManager = require("npcManager")
	npcManager.registerHarmTypes(NPC_ID, {[HARM_TYPE_JUMP] = true}, {[HARM_TYPE_JUMP] = 15})
	
	function npc.onInitAPI()
		npcManager.registerSpecialEvent(NPC_ID, npc, "onInitNPC")
	end
end

function npc.onInitNPC(v)
	SFX.play(22)
	v.speedX = 5 * v.direction
end

return npc