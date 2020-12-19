local npc = {}

function npc.onTickEndNPC(v)
	local data = v.data 
	
	if v.cantHurt > 0 then
		v.projectile = true
		v.cantHurt = 100
	else
		local C = C or 0
		
		for k,p in ipairs(Player) do
			if (p.section == v.section) and (C == 0 or (Player.getNearest(v.x + v.width / 2, v.y + v.height) ~= nil)) then
				C = Player.getNearest(v.x + v.width / 2, v.y + v.height)
				if v.x + (v.width / 2) > p.x + (p.width / 2) then
					v.direction = -1
				else
					v.direction = 1
				end
			end
		end
		v.speedX = v.speedX + (0.04 * v.direction)
		math.clamp(v.speedX, -4, 4)
	end
	
	if v.collidesBlockBottom then
		v.speedY = -(data.sY or 2)
	else
		data.sY = v.speedY * 0.7
	end
end

return npc