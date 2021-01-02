local npc = {}

local function animation(v)
	if(v.animationTimer < 8) then
		v.animationFrame = 0
	elseif(v.animationTimer < 15) then
		v.animationFrame = 1
	else
		v.animationTimer = 0
		v.animationFrame = 1
	end
	if(v.direction == 1) then
		v.animationFrame = v.animationFrame + 4
	end
	if(v.ai1 > 0 and not v.collidesBlockBottom and v.speedY < 0) then
		v.animationFrame = v.animationFrame + 2
	end
end

function npc.onTickEndNPC(v)
	animation(v)
	
	if v.ai1 == 0 then
		for k,p in ipairs(Player.getIntersecting(v.x, v.y - 256, v.x + v.width, v.y + v.height)) do
			v.ai1 = 1
			v.speedY = -7
			v.speedX = 0
		end
	elseif v.collidesBlockBottom then
		v.ai1 = 0
	end
	
	if not v.dontMove and v.ai1 == 0 then
		if v.ai2 == 0 then
			if (v.x < v.spawnX - 128 and v.direction == -1) or (v.x > v.spawnX + 128 and v.direction == 1) then v.ai2 = 60 end
			v.speedX = 1.4 * v.direction
			
			if v.collidesBlockBottom then v.speedY = -1.5 end
		else
			v.ai2 = v.ai2 - 1
			
			if v.collidesBlockBottom then v.speedX = 0 end
			
			if v.ai2 == 0 then
				if v.x < v.spawnX then
					v.direction = 1
				else
					v.direction = -1
				end
			end
		end
	end
end

return npc