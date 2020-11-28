local char = {
name = "mario",
Width = {},
Height = {},
GrabSpotX = {},
GrabSpotY = {},
DuckHeight = {}
}

char.Height[1] = 30        -- Little Mario
char.Width[1] = 24         -- ------------
char.GrabSpotX[1] = 18     -- ---------
char.GrabSpotY[1] = -2     -- ---------

char.Height[2] = 54        -- Big Mario
char.Width[2] = 24         -- ---------
char.DuckHeight[2] = 30    -- ---------
char.GrabSpotX[2] = 18     -- ---------
char.GrabSpotY[2] = 16     -- ---------

char.Height[3] = 54        -- Fire Mario
char.Width[3] = 24         -- ---------
char.DuckHeight[3] = 30    -- ---------
char.GrabSpotX[3] = 18     -- ---------
char.GrabSpotY[3] = 16     -- ---------

char.Height[7] = 54        -- Ice Mario
char.Width[7] = 24         -- ---------
char.DuckHeight[7] = 30    -- ---------
char.GrabSpotX[7] = 18     -- ---------
char.GrabSpotY[7] = 16     -- ---------

char.Height[6] = 54        -- Hammer Mario
char.Width[6] = 24         -- ---------
char.DuckHeight[6] = 30    -- ---------
char.GrabSpotX[6] = 18     -- ---------
char.GrabSpotY[6] = 16     -- ---------

char.Height[4] = 54        -- Racoon Mario
char.Width[4] = 24         -- ---------
char.DuckHeight[4] = 30    -- ---------
char.GrabSpotX[4] = 18     -- ---------
char.GrabSpotY[4] = 16     -- ---------

char.Height[5] = 54        -- Tanooki Mario
char.Width[5] = 24         -- ---------
char.DuckHeight[5] = 30    -- ---------
char.GrabSpotX[5] = 18     -- ---------
char.GrabSpotY[5] = 16     -- ---------

char.Height[8] = 32        -- Frog Mario
char.Width[8] = 16         -- ---------
char.DuckHeight[8] = 22    -- ---------
char.GrabSpotX[8] = 7     -- ---------
char.GrabSpotY[8] = 0     -- ---------

char.Height[9] = 20        -- Mini Mario
char.Width[9] = 18         -- ---------
char.DuckHeight[9] = 23    -- ---------
char.GrabSpotX[9] = 9     -- ---------
char.GrabSpotY[9] = 8     -- ---------

char.Height[10] = 54        -- Propeller Mario
char.Width[10] = 24         -- ---------
char.DuckHeight[10] = 30    -- ---------
char.GrabSpotX[10] = 18     -- ---------
char.GrabSpotY[10] = 16     -- ---------

--[[function char.onTickEndPlayer(v)
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
	
end]]

return char