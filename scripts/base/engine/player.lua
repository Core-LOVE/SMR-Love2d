local Player = {__type = "Player"}
Player.Width = {}
Player.Height = {}
Player.DuckHeight = {}
Player.GrabSpotX = {}
Player.GrabSpotY = {}
for i = 1, 5 do
	Player.Width[i] = {}
	Player.Height[i] = {}
	Player.DuckHeight[i] = {}
	Player.GrabSpotX[i] = {}
	Player.GrabSpotY[i] = {}
end

Player.Height[1][1] = 30        -- Little Mario
Player.Width[1][1] = 24         -- ------------
Player.GrabSpotX[1][1] = 18     -- ---------
Player.GrabSpotY[1][1] = -2     -- ---------
Player.Height[1][2] = 54        -- Big Mario
Player.Width[1][2] = 24         -- ---------
Player.DuckHeight[1][2] = 30    -- ---------
Player.GrabSpotX[1][2] = 18     -- ---------
Player.GrabSpotY[1][2] = 16     -- ---------
Player.Height[1][3] = 54        -- Fire Mario
Player.Width[1][3] = 24         -- ---------
Player.DuckHeight[1][3] = 30    -- ---------
Player.GrabSpotX[1][3] = 18     -- ---------
Player.GrabSpotY[1][3] = 16     -- ---------
Player.Height[1][7] = 54        -- Ice Mario
Player.Width[1][7] = 24         -- ---------
Player.DuckHeight[1][7] = 30    -- ---------
Player.GrabSpotX[1][7] = 18     -- ---------
Player.GrabSpotY[1][7] = 16     -- ---------

Player.Height[1][6] = 54        -- Hammer Mario
Player.Width[1][6] = 24         -- ---------
Player.DuckHeight[1][6] = 30    -- ---------
Player.GrabSpotX[1][6] = 18     -- ---------
Player.GrabSpotY[1][6] = 16     -- ---------

Player.Height[1][4] = 54        -- Racoon Mario
Player.Width[1][4] = 24         -- ---------
Player.DuckHeight[1][4] = 30    -- ---------
Player.GrabSpotX[1][4] = 18     -- ---------
Player.GrabSpotY[1][4] = 16     -- ---------
Player.Height[1][5] = 54        -- Tanooki Mario
Player.Width[1][5] = 24         -- ---------
Player.DuckHeight[1][5] = 30    -- ---------
Player.GrabSpotX[1][5] = 18     -- ---------
Player.GrabSpotY[1][5] = 16     -- ---------

Player.Height[1][8] = 32        -- Frog Mario
Player.Width[1][8] = 16         -- ---------
Player.DuckHeight[1][8] = 22    -- ---------
Player.GrabSpotX[1][8] = 7     -- ---------
Player.GrabSpotY[1][8] = 0     -- ---------

Player.Height[1][9] = 20        -- Mini Mario
Player.Width[1][9] = 18         -- ---------
Player.DuckHeight[1][9] = 23    -- ---------
Player.GrabSpotX[1][9] = 9     -- ---------
Player.GrabSpotY[1][9] = 8     -- ---------

Player.Height[1][10] = 54        -- Propeller Mario
Player.Width[1][10] = 24         -- ---------
Player.DuckHeight[1][10] = 30    -- ---------
Player.GrabSpotX[1][10] = 18     -- ---------
Player.GrabSpotY[1][10] = 16     -- ---------

Player.Height[2][1] = 30        -- Little Luigi
Player.Width[2][1] = 24         -- ------------
Player.GrabSpotX[2][1] = 16     -- ---------
Player.GrabSpotY[2][1] = -4     -- ---------
Player.Height[2][2] = 60        -- Big Luigi
Player.Width[2][2] = 24         -- ---------
Player.DuckHeight[2][2] = 30    -- ---------
Player.GrabSpotX[2][2] = 18     -- ---------
Player.GrabSpotY[2][2] = 16     -- ---------
Player.Height[2][3] = 60        -- Fire Luigi
Player.Width[2][3] = 24         -- ---------
Player.DuckHeight[2][3] = 30    -- ---------
Player.GrabSpotX[2][3] = 18     -- ---------
Player.GrabSpotY[2][3] = 16     -- ---------
Player.Height[2][4] = 60        -- Racoon Luigi
Player.Width[2][4] = 24         -- ---------
Player.DuckHeight[2][4] = 30    -- ---------
Player.GrabSpotX[2][4] = 18     -- ---------
Player.GrabSpotY[2][4] = 16     -- ---------
Player.Height[2][5] = 60        -- Tanooki Luigi
Player.Width[2][5] = 24         -- ---------
Player.DuckHeight[2][5] = 30    -- ---------
Player.GrabSpotX[2][5] = 18     -- ---------
Player.GrabSpotY[2][5] = 16     -- ---------
Player.Height[2][6] = 60        -- Tanooki Luigi
Player.Width[2][6] = 24         -- ---------
Player.DuckHeight[2][6] = 30    -- ---------
Player.GrabSpotX[2][6] = 18     -- ---------
Player.GrabSpotY[2][6] = 16     -- ---------
Player.Height[2][7] = 60        -- Ice Luigi
Player.Width[2][7] = 24         -- ---------
Player.DuckHeight[2][7] = 30    -- ---------
Player.GrabSpotX[2][7] = 18     -- ---------
Player.GrabSpotY[2][7] = 16     -- ---------

Player.Height[2][8] = 48        -- Frog Luigi
Player.Width[2][8] = 12         -- ---------
Player.DuckHeight[2][8] = 48    -- ---------
Player.GrabSpotX[2][8] = 18     -- ---------
Player.GrabSpotY[2][8] = 16     -- ---------

Player.Height[2][9] = 20        -- Mini Luigi
Player.Width[2][9] = 18         -- ---------
Player.DuckHeight[2][9] = 23    -- ---------
Player.GrabSpotX[2][9] = 9     -- ---------
Player.GrabSpotY[2][9] = 8     -- ---------

Player.Height[2][10] = 60        -- Propeller Luigi
Player.Width[2][10] = 24         -- ---------
Player.DuckHeight[2][10] = 30    -- ---------
Player.GrabSpotX[2][10] = 18     -- ---------
Player.GrabSpotY[2][10] = 16     -- ---------

Player.Height[3][1] = 38        -- Little Peach
Player.DuckHeight[3][1] = 26    -- ---------
Player.Width[3][1] = 24         -- ------------
Player.GrabSpotX[3][1] = 0      -- ---------
Player.GrabSpotY[3][1] = 0      -- ---------
Player.Height[3][2] = 60        -- Big Peach
Player.Width[3][2] = 24         -- ---------
Player.DuckHeight[3][2] = 30    -- ---------
Player.GrabSpotX[3][2] = 0     -- ---------
Player.GrabSpotY[3][2] = 0     -- ---------
Player.Height[3][3] = 60        -- Fire Peach
Player.Width[3][3] = 24         -- ---------
Player.DuckHeight[3][3] = 30    -- ---------
Player.GrabSpotX[3][3] = 18
Player.GrabSpotY[3][3] = 16

Player.Height[3][4] = 60        -- Racoon Peach
Player.Width[3][4] = 24         -- ---------
Player.DuckHeight[3][4] = 30    -- ---------
Player.GrabSpotX[3][4] = 18
Player.GrabSpotY[3][4] = 16

Player.Height[3][5] = 60        -- Tanooki Peach
Player.Width[3][5] = 24         -- ---------
Player.DuckHeight[3][5] = 30    -- ---------
Player.GrabSpotX[3][5] = 18
Player.GrabSpotY[3][5] = 16

Player.Height[3][6] = 60        -- Hammer Peach
Player.Width[3][6] = 24         -- ---------
Player.DuckHeight[3][6] = 30    -- ---------
Player.GrabSpotX[3][6] = 18
Player.GrabSpotY[3][6] = 16


Player.Height[3][7] = 60        -- Ice Peach
Player.Width[3][7] = 24         -- ---------
Player.DuckHeight[3][7] = 30    -- ---------
Player.GrabSpotX[3][7] = 18
Player.GrabSpotY[3][7] = 16

Player.Height[3][8] = 46        -- Frog Peach
Player.Width[3][8] = 12         -- ---------
Player.DuckHeight[3][8] = 46    -- ---------
Player.GrabSpotX[3][8] = 18
Player.GrabSpotY[3][8] = 16

Player.Height[3][9] = 20        -- Mini Peach
Player.Width[3][9] = 18         -- ---------
Player.DuckHeight[3][9] = 23    -- ---------
Player.GrabSpotX[3][9] = 9     -- ---------
Player.GrabSpotY[3][9] = 8     -- ---------

Player.Height[3][10] = 60        -- Propeller Peach
Player.Width[3][10] = 24         -- ---------
Player.DuckHeight[3][10] = 30    -- ---------
Player.GrabSpotX[3][10] = 0     -- ---------
Player.GrabSpotY[3][10] = 0     -- ---------

Player.Height[4][1] = 30        -- Little Toad
Player.Width[4][1] = 24         -- ------------
Player.DuckHeight[4][1] = 26    -- ---------
Player.GrabSpotX[4][1] = 18     -- ---------
Player.GrabSpotY[4][1] = -2     -- ---------
Player.Height[4][2] = 50        -- Big Toad
Player.Width[4][2] = 24         -- ---------
Player.DuckHeight[4][2] = 30    -- ---------
Player.GrabSpotX[4][2] = 18     -- ---------
Player.GrabSpotY[4][2] = 16     -- ---------
Player.Height[4][3] = 50        -- Fire Toad
Player.Width[4][3] = 24         -- ---------
Player.DuckHeight[4][3] = 30    -- ---------
Player.GrabSpotX[4][3] = 18     -- ---------
Player.GrabSpotY[4][3] = 16     -- ---------

Player.Height[4][4] = 50        -- Racoon Toad
Player.Width[4][4] = 24         -- ---------
Player.DuckHeight[4][4] = 30    -- ---------
Player.GrabSpotX[4][4] = 18     -- ---------
Player.GrabSpotY[4][4] = 16     -- ---------

Player.Height[4][5] = 50        -- Tanooki Toad
Player.Width[4][5] = 24         -- ---------
Player.DuckHeight[4][5] = 30    -- ---------
Player.GrabSpotX[4][5] = 18     -- ---------
Player.GrabSpotY[4][5] = 16     -- ---------

Player.Height[4][6] = 50        -- Hammer Toad
Player.Width[4][6] = 24         -- ---------
Player.DuckHeight[4][6] = 30    -- ---------
Player.GrabSpotX[4][6] = 18     -- ---------
Player.GrabSpotY[4][6] = 16     -- ---------

Player.Height[4][7] = 50        -- Ice Toad
Player.Width[4][7] = 24         -- ---------
Player.DuckHeight[4][7] = 30    -- ---------
Player.GrabSpotX[4][7] = 18     -- ---------
Player.GrabSpotY[4][7] = 16     -- ---------

Player.Height[4][8] = 48        -- Frog Toad
Player.Width[4][8] = 12         -- ---------
Player.DuckHeight[4][8] = 44    -- ---------
Player.GrabSpotX[4][8] = 18     -- ---------
Player.GrabSpotY[4][8] = 16     -- ---------

Player.Height[4][9] = 20        -- Mini Toad
Player.Width[4][9] = 18         -- ---------
Player.DuckHeight[4][9] = 23    -- ---------
Player.GrabSpotX[4][9] = 9     -- ---------
Player.GrabSpotY[4][9] = 8     -- ---------

Player.Height[4][10] = 50        -- Propeller Toad
Player.Width[4][10] = 24         -- ---------
Player.DuckHeight[4][10] = 30    -- ---------
Player.GrabSpotX[4][10] = 18     -- ---------
Player.GrabSpotY[4][10] = 16     -- ---------

Player.Height[5][1] = 54        -- Green Link
Player.Width[5][1] = 22         -- ---------
Player.DuckHeight[5][1] = 44    -- ---------
Player.GrabSpotX[5][1] = 18     -- ---------
Player.GrabSpotY[5][1] = 16     -- ---------

Player.Height[5][2] = 54        -- Green Link
Player.Width[5][2] = 22         -- ---------
Player.DuckHeight[5][2] = 44    -- ---------
Player.GrabSpotX[5][2] = 18     -- ---------
Player.GrabSpotY[5][2] = 16     -- ---------

Player.Height[5][3] = 54        -- Fire Link
Player.Width[5][3] = 22         -- ---------
Player.DuckHeight[5][3] = 44    -- ---------
Player.GrabSpotX[5][3] = 18     -- ---------
Player.GrabSpotY[5][3] = 16     -- ---------

Player.Height[5][4] = 54        -- Blue Link
Player.Width[5][4] = 22         -- ---------
Player.DuckHeight[5][4] = 44    -- ---------
Player.GrabSpotX[5][4] = 18     -- ---------
Player.GrabSpotY[5][4] = 16     -- ---------

Player.Height[5][5] = 54        -- IronKnuckle Link
Player.Width[5][5] = 22         -- ---------
Player.DuckHeight[5][5] = 44    -- ---------
Player.GrabSpotX[5][5] = 18     -- ---------
Player.GrabSpotY[5][5] = 16     -- ---------

Player.Height[5][6] = 54        -- Shadow Link
Player.Width[5][6] = 22         -- ---------
Player.DuckHeight[5][6] = 44    -- ---------
Player.GrabSpotX[5][6] = 18     -- ---------
Player.GrabSpotY[5][6] = 16     -- ---------

Player.Height[5][7] = 54        -- Ice Link
Player.Width[5][7] = 22         -- ---------
Player.DuckHeight[5][7] = 44    -- ---------
Player.GrabSpotX[5][7] = 18     -- ---------
Player.GrabSpotY[5][7] = 16     -- ---------

Player.Height[5][8] = 54        -- Frog Link
Player.Width[5][8] = 22         -- ---------
Player.DuckHeight[5][8] = 44    -- ---------
Player.GrabSpotX[5][8] = 18     -- ---------
Player.GrabSpotY[5][8] = 16     -- ---------

Player.Height[5][9] = 20        -- Mini Link
Player.Width[5][9] = 18         -- ---------
Player.DuckHeight[5][9] = 23    -- ---------
Player.GrabSpotX[5][9] = 9     -- ---------
Player.GrabSpotY[5][9] = 8     -- ---------

Player.Height[5][10] = 54        -- Propeller Link
Player.Width[5][10] = 22         -- ---------
Player.DuckHeight[5][10] = 44    -- ---------
Player.GrabSpotX[5][10] = 18     -- ---------
Player.GrabSpotY[5][10] = 16     -- ---------

setmetatable(Player, {__call=function(Player, idx)
	return Player[idx] or Player
end})

function Player.spawn(character, x, y)
	local p = {
		idx = #Player + 1,
		isValid = true,
		
		character = character or 1,
		powerup = 1,
		x = x or 0,
		y = y or 0,
		reservePowerup = nil,
		width = Player.Width[character or 1][1],
		height = Player.Height[character or 1][1],
		holdingNPC = {},
		keys = newControls()
	}
	
	Player[#Player + 1] =  p
	return p
end

return Player