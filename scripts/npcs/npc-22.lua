local npc = {}

function npc.onTickEndNPC(v)
	if v.grabbedPlayer then
		v.ai1 = v.ai1 + 10
		if v.ai1 >= 200 then
			v.ai1 = 0
			
			SFX.play(22)
			
			Effect.spawn(10, v.x + (32 * v.direction), v.y)
			
			local c = NPC.config[17]
			
			local w = 0
			if v.grabbedPlayer.direction == 1 then
				w = v.width * 2
			end
			
			local b = NPC.spawn(17, v.x - c.width + w, v.y - (c.height / 2) + 16, v.section)
			b.projectile = true
			b.direction = v.grabbedPlayer.direction
			b.speedX = 8 * v.grabbedPlayer.direction
		end
	end
end

return npc