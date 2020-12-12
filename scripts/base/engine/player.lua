local Player = {__type = "Player"}

Player.script = {}
Player.frames = require("scripts/base/engine/player_frames")

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
	
	if love.filesystem.getInfo("scripts/characters/character-"..tostring(i)..".lua") then
		Player.script[i] = require("scripts/characters/character-"..tostring(i))
	else
		Player.script[i] = {}
	end
end

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



local function physics(v)
	if v.keys.left then
		v.direction = -1
	elseif v.keys.right then
		v.direction = 1
	end
	
	local scr = Player.script[v.character]
	if scr ~= nil then
		v.width = scr.Width[v.powerup] or 32
		v.height = scr.Height[v.powerup] or 32
	end

	-- Walking/running
	local walkDirection = (v.keys.left and -1) or (v.keys.right and 1) or 0

	local speedModifier = 1

	local walkSpeed = Defines.player_walkspeed*speedModifier
	local runSpeed = Defines.player_runspeed*speedModifier

	if walkDirection ~= 0 then
		local speedingUpForWalk = (v.speedX*walkDirection < walkSpeed)

		if v.keys.run or speedingUpForWalk then
			if speedingUpForWalk then
				v.speedX = v.speedX + Defines.player_walkingAcceleration*speedModifier*walkDirection
			elseif v.speedX*walkDirection < runSpeed then
				v.speedX = v.speedX + Defines.player_runningAcceleration*speedModifier*walkDirection
			end

			if v.speedX*walkDirection < 0 then
				v.speedX = v.speedX + Defines.player_turningAcceleration*walkDirection
			end
		else
			v.speedX = v.speedX - Defines.player_runToWalkDeceleration*walkDirection
		end
	elseif v.collidesBlockBottom then
		if v.speedX > 0 then
			v.speedX = math.max(0,v.speedX - Defines.player_deceleration*speedModifier)
		elseif v.speedX < 0 then
			v.speedX = math.min(0,v.speedX + Defines.player_deceleration*speedModifier)
		end
	end


	-- Jumping
	if v.keys.jump then
		if v.collidesBlockBottom and v.keys.jump == KEYS_PRESSED then
			SFX.play(1)
		end
		
		if v.keys.jump == KEYS_PRESSED and v.collidesBlockBottom then
			v.jumpForce = Defines.jumpheight
		end

		if v.jumpForce > 0 then
			v.speedY = Defines.player_jumpspeed-math.abs(v.speedX*0.2)
		end
	end

	if not v.keys.jump and not v.keys.altJump then
		v.jumpForce = 0
	elseif v.jumpForce > 0 then
		v.jumpForce = math.max(0,v.jumpForce - 1)
	end

	v.speedY = math.min(Defines.gravity,v.speedY + Defines.player_grav)

	
	BasicColliders.applySpeedWithCollision(v)
end



local newControls


setmetatable(Player, {__call=function(Player, idx)
	return Player[idx] or Player
end})

function Player.spawn(character, x, y)
	local p = {
		__type = "Player",

		idx = #Player + 1,
		isValid = true,
		
		character = character or 1,
		powerup = 1,
		x = x or 0,
		y = y or 0,
		speedX = 0,
		speedY = 0,
		reservePowerup = 0,
		direction = 1,
		
		frame = 1,
		frameTimer = 0,
		
		nogravity = 0,
		vine = 0,
		holdingNPC = nil,
		keys = newControls(),
		rawKeys = newControls(),
		
		section = 0,
		
		jumpForce = 0,
	}
	
	BasicColliders.addCollisionProperties(p)
	BasicColliders.addSolidObjectProperties(p)
	
	local scr = Player.script[p.character]
	if scr ~= nil then
		p.width = scr.Width[p.powerup] or 32
		p.height = scr.Height[p.powerup] or 32
		p.name = scr.name or "mario"
	else
		p.width = 32
		p.height = 32
		
		if p.character == 1 then
			p.name = "mario"
		elseif p.character == 2 then
			p.name = "luigi"
		else
			p.name = "null"
		end
	end
	
	Player[#Player + 1] =  p
	return p
end

function Player.update()
	for k,v in ipairs(Player) do
		local scr = Player.script[v.character]
		
		if scr ~= nil then
			if scr.onPhysicsPlayer ~= nil then scr.onPhysicsPlayer(v) else physics(v) end
			if scr.onAnimationPlayer ~= nil then scr.onAnimationPlayer(v) end
			if scr.onTickEndPlayer ~= nil then scr.onTickEndPlayer(v) end
			if scr.onTickPlayer ~= nil then scr.onTickPlayer(v) end
		else
			physics(v)
		end
	end
end

function Player:isGroundTouching()
	if self.collidesBlockBottom then return true end
	return false
end

function Player:kill()

end
-- Keys (heavily based on the x2 rendition)
do
	KEYS_UP = false
	KEYS_RELEASED = nil
	KEYS_PRESSED = 1
	KEYS_DOWN = true

	local keysMT = {
		__index = (function(self,key)
			local last = self._last[key]
			local now = self._now[key]

			if not last and not now then
				return KEYS_UP
			elseif last and not now then
				return KEYS_RELEASED
			elseif not last and now then
				return KEYS_PRESSED
			else
				return KEYS_DOWN
			end
		end),
		__newindex = (function(self,key,value)
			self._now[key] = (not not value)
		end),
	}

	function newControls()
		local keys = {}

		keys._last = {}
		keys._now = {}

		setmetatable(keys,keysMT)

		return keys
	end


	local inputs = {"up","right","down","left","jump","run","altJump","altRun","pause","dropItem"}

	-- TODO: replace this entirely
	local inputConfig = {
		up = "up",
		right = "right",
		down = "down",
		left = "left",
		jump = "z",
		run = "x",
		altJump = "a",
		altRun = "s",
		pause = "escape",
		dropItem = "rshift",
	}


	local function updateKeys(keys,inputConfig)
		for _,name in ipairs(inputs) do
			keys._last[name] = keys._now[name]
			keys._now[name] = love.keyboard.isDown(inputConfig[name])
		end
	end
	
	function Player.updateKeys()
		for _,v in ipairs(Player) do
			updateKeys(v.rawKeys,inputConfig)
			updateKeys(v.keys,inputConfig)

			if v.keys.left and v.keys.right then
				v.keys.left = false
				v.keys.right = false
			end
			if v.keys.up and v.keys.down then
				v.keys.up = false
				v.keys.down = false
			end
		end
	end
end


return Player