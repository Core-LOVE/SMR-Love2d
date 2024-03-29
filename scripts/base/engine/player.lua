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
	-- Section check
	if v.section == nil or v.section == 0 then
		for k,s in ipairs(Section.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
			v.section = s.idx
		end
	end
	
	if v.deathState then return end
	
	-- Direction stuff
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
		if v.isSpinjumping then v.isSpinjumping = false end
		
		if v.speedX > 0 then
			v.speedX = math.max(0,v.speedX - Defines.player_deceleration*speedModifier)
		elseif v.speedX < 0 then
			v.speedX = math.min(0,v.speedX + Defines.player_deceleration*speedModifier)
		end
	end


	-- Jumping
	if v.keys.jump or v.keys.altJump then
		if v.slidingSlope then v.slidingSlope = false end
		
		if (v.keys.jump == KEYS_PRESSED or v.keys.altJump == KEYS_PRESSED) and v.collidesBlockBottom then
			v.jumpForce = Defines.jumpheight
			if v.keys.altJump then
				v.jumpForce = Defines.spinjumpheight
				v.direction = -v.direction
				
				v.isSpinjumping = true
				SFX.play(33)	
			else
				v.isSpinjumping = false
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

	for k,n in ipairs(NPC.getIntersecting(v.x - 1, v.y - v.height - 1, v.x + v.width + 1, v.y + v.height + 1)) do
		if not n.friendly then
			if n.despawnTimer > 0 then
				local config = NPC.config[n.id]

				-- Hit from top
				if BasicColliders.side(v,n) == COLLISION_SIDE_TOP then
					local harmType
					if v.isSpinjumping and (config.damageMap[HARM_TYPE_SPINJUMP] ~= nil or config.spinjumpsafe) then
						harmType = HARM_TYPE_SPINJUMP
					elseif (v.isSpinjumping or not config.jumphurt) and config.damageMap[HARM_TYPE_JUMP] ~= nil then
						harmType = HARM_TYPE_JUMP
					end

					if harmType ~= nil then
						n:harm(harmType, nil, v)

						Effect.spawn(75, v.x + v.width / 2 - 16, v.y + v.height / 2 - 16)
						
						if harmType == HARM_TYPE_SPINJUMP and not config.jumphurt then
							SFX.play(36)
							Effect.spawn(76, n.x + n.width / 2, n.y + n.height / 2)
							v.y = n.y - n.height - 1
							v.speedY = -5.69
						else
							SFX.play(2)
							v.y = n.y - n.height - 1
							v.jumpForce = Defines.jumpheight_bounce + n.speedY
							v.speedY = Defines.player_jumpspeed - math.abs(v.speedX*0.2)	
						end
					end
				else
					v:harm()
				end
				
				-- Grabbing
				if (v.holdingNPC == nil and v.keys.run and n.grabbingPlayer == nil) and v.y > n.y and (config.grabside or config.isshell) then
					local sfx = 23
					if config.isshell then
						sfx = nil
					end

					n:grab(v, sfx)
				end
			end	
		end
	end
	
	-- BasicColliders.applySpeedWithCollision(v)
	
	-- Grabbed NPC
	local hnpc = v.holdingNPC
	if hnpc then
		local gX = (scr.GrabSpotX[v.powerup] * v.direction) or 0
		local gY = scr.GrabSpotY[v.powerup] or 0
		
		hnpc.x = v.x + gX
		hnpc.y = v.y + gY
		
		if not v.keys.run then
			local bool = true
			if v.keys.down then
				bool = false
			end
			hnpc:ungrab(bool, 9)
		end
	end
	
	-- Warping
	for k,wp in ipairs(Warp.getIntersectingEntrance(v.x, v.y, v.x + v.width, v.y + v.height)) do
		if v.keys.up then
			v:warp(wp)
		end
	end
	
	if v.TargetWarpIndex > 0 then
		local w = Warp(v.TargetWarpIndex)
		
		v.x = math.floor(w.entranceX / 32) * 32 + 4
		v.y = math.floor(w.entranceY / 32) * 32
		v.speedY = 0
		v.speedX = 0
		
		v.WarpTimer = v.WarpTimer + 1
		if v.WarpTimer >= 32 then
			for _,s in ipairs(Section.getIntersecting(w.exitX, w.exitY, w.exitX + w.exitWidth, w.exitY + w.exitHeight)) do
				v.section = s.idx
			end
			
			v.x = math.floor(w.exitX / 32) * 32 + 4
			v.y = math.floor(w.exitY / 32) * 32 + 2
		
			v.WarpTimer = 0
			v.WarpCooldownTimer = 16
			v.TargetWarpIndex = 0
		end
	end
	
	if v.WarpCooldownTimer > 0 then
		v.WarpCooldownTimer = v.WarpCooldownTimer - 1
	end
	-- Clamp hor pos
	local sb = Section(v.section).boundary
	
	if v.clampHorizontalPos then
		if v.x < sb.left then
			v.x = sb.left
			v.speedX = 0
		elseif v.x + v.width > sb.right then
			v.x = sb.right - v.width
			v.speedX = 0
		end
		
		v.x = math.clamp(v.x, sb.left, sb.right - v.width)
		-- v.y = math.clamp(v.y, sb.top, sb.bottom - v.height)
	end
	
	-- Sliding
	if ((v.keys.right and v.speedX < 0) or (v.keys.left and v.speedX > 0)) and v.collidesBlockBottom then
		v.slideCounter = v.slideCounter - 1
		if v.slideCounter <= 0 then
			SFX.play(10)
			Effect.spawn(74, v.x + (v.width / 2) - 4 + 10 * -v.direction, v.y + (v.height - 5))
			v.slideCounter = 2 + math.random(0,2)
		end
		SFX.play(10)
	else
		if v.slideCounter ~= 0 then
			v.slideCounter = 0
		end
	end
	
	-- Pit death
	if v.y + v.height > sb.bottom + v.height * 2 + 11 then
		v:kill()
	end
	
	-- Slope stuff
	if v.collidingSlope ~= nil then
		if not v.slidingSlope then
			local cs = Block.config[v.collidingSlope.id]
			
			if cs.floorslope == -1 and v.speedX > 5.25 then
				v.speedX = 5.25
			elseif cs.floorslope == 1 and v.speedX < -5.25 then
				v.speedX = -5.25
			end
			
			if v.keys.down and not v.holdingNPC then
				v.slidingSlope = true
			end
		else
			local so = v.collidingSlope 
			
			local x1, x2 = v.x + v.width, v.x
			local y1, y2 = v.y + v.height, v.y
			
			local acl = math.atan2(x1 - x2, y1 - y2) * 0.5
			
			v.speedX = v.speedX + (acl * v.direction)
		end
	else
		if v.speedX == 0 then
			v.slidingSlope = false
		end
	end
	
	Physics.applyCollisions(v)
end

local newControls

setmetatable(Player, {__call=function(Player, idx)
	return Player[idx]
end})

local playerMT = {__type = Player.__type, __index = Player}

function Player.spawn(character, x, y)
	local p = {
		__type = "Player",
		
		isValid = true,
		idx = #Player + 1,
		
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
		
		deathState = false,
		deathTimer = 0,
		
		TargetWarpIndex = 0,
		WarpCooldownTimer = 0,
		WarpTimer = 0,

		slideCounter = 0,
		slidingSlope = false,
		
		isSpinjumping = false,
		spinjumpTimer = 0,
		spinJumpDirection = 0,	
		
		holdingNPC = nil,
		keys = newControls(),
		rawKeys = newControls(),
		
		section = 0,
		clampHorizontalPos = true,
		
		jumpForce = 0,
	}
	
	setmetatable(p, playerMT)
	
	-- BasicColliders.addCollisionProperties(p)
	-- BasicColliders.addSolidObjectProperties(p)
	
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
	
	Physics.add(p)
	
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
	return self.collidesBlockBottom
end

function Player:isOnGround()
	return self.collidesBlockBottom
end

function Player:harm()
	if self.powerup == 1 then
		self:kill()
	else
	
	end
end

function Player:warp(warpObj, warpType, warpDirection)
	local v = self
	if v.WarpCooldownTimer > 0 then return end
	
	if warpObj.__type == "Warp" then
		local w = warpObj
		
		v.x = math.floor(w.entranceX / 32) * 32
		v.y = math.floor(w.entranceY / 32) * 32

		local tb = {[1] = "entrance", [2] = "exit"}
		for i = 1, #tb do
			local x = w[tb[i].."X"]
			local y = w[tb[i].."Y"]
			local wd = x + w[tb[i].."Width"]
			local hg = y + w[tb[i].."Height"]
			
			for k,b in ipairs(BGO.getIntersecting(x,y,wd,hg)) do
				if BGO.config[b.id].dooreffect ~= 0 then
					Effect.spawn(BGO.config[b.id].dooreffect, b.x + b.width / 2, b.y + b.height / 2)
				end
			end
		end
		
		v.WarpCooldownTimer = 32
		v.TargetWarpIndex = w.idx
		
		if w.warpType == 2 then
			SFX.play(46)
		end
	elseif warpObj.__type == nil and #warpIdx == 4 then
		
	end
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
	if self.deathState then return end
	
	local scr = Player.script[self.character]
	local e
	
	self.speedX = 0
	self.speedY = 0
	
	if #Player >= 2 then
		local tempBool = false
		
		for _,p in ipairs(Player) do
			if not p.deathState and self ~= p then
				tempBool = true
			end
		end
		
		if tempBool then
			SFX.play(54)
		else
			SFX.play(8)
		end
	elseif #Player == 1 then
		SFX.play(8)
	end
	
	if type(scr.deathEffect) == 'number' then e = Effect.spawn(scr.deathEffect, self.x, self.y) end
	
	self.deathState = true
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

_G.player = Player[1]

return Player