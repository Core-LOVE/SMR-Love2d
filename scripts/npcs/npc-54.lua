local npc = {}

function npc.onInitAPI()
	local npcManager = require("npcManager")
	npcManager.registerEvent(NPC_ID, npc, "onTickEndNPC")
end

function npc.onTickEndNPC(v)

end

return npc