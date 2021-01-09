local npc = {}

function npc.onInitAPI()
	local npcManager = require("npcManager")
	npcManager.registerEvent(NPC_ID, npc, "onTickEndNPC")
end

function npc.onTickEndNPC(v)
	local C = 0
	
	if C == 0 or #Player.getNearest(v.x + v.width / 2, v.y + v.height) < C then
		C = Player.getNearest(v.x + v.width / 2, v.y + v.height)
	end
	
	if v.x + (v.width / 2) > C.x + (C.width / 2) then
		v.direction = -1
	else
		v.direction = 1
	end
	
	if math.random(0, 300) > 297 and v.ai1 == 0 then
		v.ai1 = 1
	end
	
	v.ai4 = v.ai4 + 1
	
	if(math.random(0, 40) + 80 >= v.ai4) then -- random number from 80 to 120
		if(math.random(0, 100) <= 40 and v.ai4 % 16 == 0) then
			SFX.play(25)
			
			local id = 30
			local cn = NPC.config[id]
			
			local n = NPC.spawn(30, v.x + v.width / 2 - (cn.width / 2), v.y - cn.height, v.section)
			
			if v.direction == 1 then n.frame = 4 end
			
			n.layer = "Spawned NPCs"
			n.speedX = 3 * v.direction
			n.speedY = -8
		end
	else
		if(math.random(0, 50) + 300 < v.ai4) then -- random number from 300 to 350
			v.ai4 = 0
		end
	end
	
	if v.ai1 == 0 then
		if v.ai2 == 0 then
			v.speedX = -0.5
			if v.x < v.spawnX - v.width * 1.5 then
				v.ai2 = 1
			end
		else
			v.speedX = 0.5
			if v.x > v.spawnX + v.width * 1.5 then
				v.ai2 = 0
			end
		end
		
		if v.collidesBlockBottom and math.random(0, 200) >= 198 then
			v.speedY = -8
		end
	end
	
			-- local x = v.x - 40
			-- if v.direction == 1 then x = v.x + 54 end
			-- local sy1, sy2 = (v.x + v.width / 2) - (C.x + C.width / 2), (v.y + v.height / 2) - (C.y + C.height / 2)
			-- n.speedY = sy1 / sy2 * n.speedX
end

return npc