local t = 0

function onTick()
	t = t + 1
	if t > 20 then
		local s = {
		[1] = 53,
		[2] = 54
		}
		
		NPC.spawn(s[math.floor(math.random(1,2))], -199552, -200224)
		t = -20
	end
end

