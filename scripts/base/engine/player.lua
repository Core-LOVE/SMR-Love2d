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
		if v.IsSpinjumping then v.IsSpinjumping = false end
		
		if v.speedX > 0 then
			v.speedX = math.max(0,v.speedX - Defines.player_deceleration*speedModifier)
		elseif v.speedX < 0 then
			v.speedX = math.min(0,v.speedX + Defines.player_deceleration*speedModifier)
		end
	end


	-- Jumping
	if v.keys.jump or v.keys.altJump then
		if (v.keys.jump == KEYS_PRESSED or v.keys.altJump == KEYS_PRESSED) and v.collidesBlockBottom then
			v.jumpForce = Defines.jumpheight
			if v.keys.altJump then
				v.IsSpinjumping = true
				SFX.play(33)	
			else
				v.IsSpinjumping = false
				SFX.play(1)
			end
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

	for k,n in ipairs(NPC.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
		local nc = NPC.config[n.id]
		-- Spinjumping
		if (v.IsSpinjumping and v.speedY >= Defines.player_grav) and (v.y <= n.y and nc.spinjumpsafe) then
			Effect.spawn(75, v.x + v.width / 2 - 16, v.y + v.height / 2 - 16)
			SFX.play(2)
			v.jumpForce = Defines.jumpheight
			v.speedY = Defines.player_jumpspeed-math.abs(v.speedX*0.2)
		end
		
		-- Grabbing
		if (v.holdingNPC == nil and v.keys.run and n.grabbedPlayer == nil) and v.y > n.y and (nc.grabside or nc.isshell) then
			local sfx = 23
			if nc.isshell then
				sfx = nil
			end
			n:grab(v, sfx)
		end
	end
	
	BasicColliders.applySpeedWithCollision(v)
	
	-- Grabbed NPC
	local hnpc = v.holdingNPC
	if hnpc then
		local gX = (scr.GrabSpotX[v.powerup] * v.direction) or 0
		local gY = scr.GrabSpotY[v.powerup] or 0
		
		hnpc.x = v.x + gX
		hnpc.y = v.y + gY
		
		if v.keys.run == KEYS_RELEASED then
			local bool = true
			if v.keys.down then
				bool = false
			end
			hnpc:ungrab(bool, 9)
		end
	end
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
		
		DeathState = false,
		DeathTimer = 0,
		
		IsSpinjumping = false,
		SpinjumpStateCounter = 0,
		SpinjumpLandDirection = 0,	
		
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

function Player.count()
	return #Player
end

function Player:isGroundTouching()
	if self.collidesBlockBottom then return true end
	return false
end

function Player.getIntersecting(x1,y1,x2,y2)
	local ret = {}

	for _,v in ipairs(Player) do
		if v.x <= x2 and v.y <= y2 and v.x+v.width >= x1 and v.y+v.height >= y1 then
			ret[#ret + 1] = v
		end
	end

	return ret
end
	
function Player.getNearest(x, y)
	if type(x) ~= "number" or type(y) ~= "number" then
		error("Invalid parameters to getNearest")
	end
	
	local players = #Player
	if #Player == 1 then
		return Player(1)
	else
		local p
		local dist = math.huge
		for _, v in ipairs(Player) do
			if not v.dead then
				local dx, dy = math.abs(v.x + v.width / 2 - x), math.abs(v.y + v.height / 2 - y)
				local cdist = math.sqrt(dx * dx + dy * dy)
				if cdist < dist then
					dist = cdist
					p = v
				end
			end
		end
		return p or player
	end
end

function Player:kill()

end
-- Keys (heavily based on the x2 rendition)
do
	KEYS_UP = false
	KEYS_RELEASED = nil
	KEYS_DOWN = true
	KEYS_PRESSED = 1

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

player = Player(1)
if Player.count() > 1 then
	for k = 2, Player.count() do
		_G['player'..tostring(k)] = Player(k)
	end
end

return Player