local char = {
name = "mario",
Width = {},
Height = {},
GrabSpotX = {},
GrabSpotY = {},
DuckHeight = {}
}

char.deathEffect = 3

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

local function animation_onFloor(v, fr, i)
	if v.speedX ~= 0 then
		if v.slideCounter <= 0 then
			v.frameTimer = v.frameTimer + 1
			if v.speedX > Defines.player_walkspeed - 1.5 or v.speedX < -Defines.player_walkspeed + 1.5 then
				v.frameTimer = v.frameTimer + 1 end
			if v.speedX > Defines.player_walkspeed or v.speedX < -Defines.player_walkspeed then
				v.frameTimer = v.frameTimer + 1 end
			if v.speedX > Defines.player_walkspeed + 1 or v.speedX < -Defines.player_walkspeed - 1 then
				v.frameTimer = v.frameTimer + 1 end
			if v.speedX > Defines.player_walkspeed + 2 or v.speedX < -Defines.player_walkspeed - 2 then
				v.frameTimer = v.frameTimer + 1 end

			if v.frameTimer >= 10 then
				v.frameTimer = 0
				if v.frame == fr.stand[i] then v.frame = fr.run[i] else v.frame = fr.stand[i] end
			end
		else
			v.frame = 4
		end
	else
		v.frame = fr.stand[i] 
	end
end

local function animation_inAir(v, fr, i)
	if v.isSpinjumping then
		local fspeed = 3
		v.frameTimer = v.frameTimer + 1
		if v.frameTimer < fspeed then
			v.direction = 1
			v.frame = fr.stand[i]
		elseif v.frameTimer < fspeed * 2 then
			v.frame = 15
		elseif v.frameTimer < fspeed * 3 then
			v.direction = -1
			v.frame = fr.stand[i]
		elseif v.frameTimer < fspeed * 4 then
			v.frame = 13 
		elseif v.frameTimer >= fspeed * 5 then
			v.direction = 1
			v.frame = fr.stand[i]
			v.frameTimer = 0
		end
	else
		v.frame = fr.jump[i]
	end
end

function char.onAnimationPlayer(v)
	local fr = {
		stand = {[1] = 1, [2] = 5},
		run = {[1] = 2, [2] = 6},
		jump = {[1] = 3, [2] = 6},
	}
	
	local i = 1
	if v.holdingNPC then
		i = 2
	end
	
	if v.TargetWarpIndex == 0 then
		if v.collidesBlockBottom then
			animation_onFloor(v, fr, i)
		else
			animation_inAir(v, fr, i)
		end
	else
		v.frame = 13
	end
end

function char.onTickEndPlayer(v)

end

return char