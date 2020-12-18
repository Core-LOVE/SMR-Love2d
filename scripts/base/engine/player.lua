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
		if v.keys.jump == KEYS_PRESSED and v.collidesBlockBottom then
			v.jumpForce = Defines.jumpheight
			SFX.play(1)
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