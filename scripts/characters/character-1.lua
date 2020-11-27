local char = {name = "mario"}

function char.onTickEndPlayer(v)
	if v.vine == 0 and v.nogravity == 0 then
		v.speedY = v.speedY + Defines.player_grav
		
		if v.holdingNPC ~= nil and (v.holdingNPC.id == 278 or v.holdingNPC == 279) then
			if (v.keys.jump or v.keys.altJump) then
				v.speedY = v.speedY - (Defines.player_grav * 0.8)
				
				if v.speedY > Defines.player_grav * 3 then
					v.speedY = Defines.player_grav * 3
				end
			else
				v.holdingNPC.ai1 = 0
			end
		end
		
		if v.speedY > Defines.gravity then
			v.speedY = Defines.gravity
		end
	elseif v.nogravity ~= 0 then
		v.nogravity = v.nogravity - 1
	end
	
end

return char