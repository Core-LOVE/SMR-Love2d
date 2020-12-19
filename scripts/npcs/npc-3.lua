local npc = {}

local function animation(v)
	if v.collidesBlockBottom then    
		if(v.animationTimer >= 8) then
			v.animationTimer = 0
			v.animationFrame = v.animationFrame + 1
			if(v.animationFrame >= 2) then
				v.animationFrame = 0
			end
		end
	else
		if(v.animationTimer >= 4) then
			v.animationTimer = 0
			if(v.animationFrame == 0) then
				v.animationFrame = 2
			elseif(v.animationFrame == 1) then
				v.animationFrame = 3
			elseif(v.animationFrame == 2) then
				v.animationFrame = 1
			elseif(v.animationFrame == 3) then
				v.animationFrame = 0
			end
		end
	end
end

function npc.onTickEndNPC(v)
	animation(v)
	
	if not v.collidesBlockBottom then return end

	if v.ai1 <= 30 then
		v.ai1 = v.ai1 + 1
	elseif v.ai1 == 31 or v.ai1 == 32 or v.ai1 == 33 then
		v.ai1 = v.ai1 + 1
		v.speedY = -4
	elseif v.ai1 == 34 then
		v.speedY = -7
		v.ai1 = 0
	end	
end

return npc