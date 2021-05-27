local NPC = {__type="NPC"}

local npcManager

NPC_MAX_ID = 1000

NPC.config = require("engine/npcConfig")
NPC.config.load()

-- Load npc-n.lua files
NPC.script = {}
setmetatable(NPC.script, {__index = function(t, id)
	if love.filesystem.getInfo("scripts/npcs/npc-".. id.. ".lua") then
		NPC_ID = id

		t[id] = require("scripts/npcs/npc-".. id)

		NPC_ID = nil
		
		return t[id]
	end
end})

function NPC.load()

end


local npcManager
local function callSpecialEvent(v,eventName)
	npcManager = npcManager or require("npcManager")
	npcManager.callSpecialEvent(v,eventName)
end


local function returnToSpawnPosition(v)
	callSpecialEvent(v,"onDeinitNPC")

	if v.spawnId <= 0 then
		v:kill(HARM_TYPE_VANISH)
		return
	end

	v.x = v.spawnX
	v.y = v.spawnY
	v.width = v.spawnWidth
	v.height = v.spawnHeight
	v.speedX = v.spawnSpeedX
	v.speedY = v.spawnSpeedY
	v.direction = v.spawnDirection
	v.id = v.spawnId
end

local function physics(v)
	if v.isHidden and v.despawnTimer > 0 then
		v.despawnTimer = 0
		returnToSpawnPosition(v)
		return
	elseif v.despawnTimer <= 0 then
		return
	end

	v.despawnTimer = v.despawnTimer - 1

	if v.despawnTimer <= 0 then
		v.despawnTimer = -1
		returnToSpawnPosition(v)
		return
	end


	local config = NPC.config[v.id]

	if v.turnAround then
		v.direction = -v.direction
		v.speedX = -v.speedX
		v.turnAround = false
	end

	if config.iswalker and not config.ismushroom then
		v.speedX = Defines.npc_walkingspeed * v.direction
	elseif config.ismushroom then
		v.speedX = Defines.npc_mushroomspeed * v.direction
	end
	
	if config.isshell then
		if v.speedX == 0 then
			v.animationFrame = 0
			v.animationTimer = 0
		end
	end
	
	if config.cliffturn and not v.projectile then
		for k,b in ipairs(Block) do
			local tempLoc = {
				x = v.x,
				y = v.y,
				width = 16,
				height = 16
			}
			tempLoc.y = tempLoc.y + tempLoc.height - 8
			tempLoc.height = 16
			
			if v.collidingSlope ~= nil and v.collidingSlope > 0 then
				tempLoc.height = 32
			end
			tempLoc.width = 16
			
			if v.direction > 0 then 
				tempLoc.x = tempLoc.x + v.width - 20
			else 
				tempLoc.x = tempLoc.x - v.width + 20
			end
			
			if not BasicColliders.check(tempLoc, b) then
				v.turnAround = true
				break
			else
				v.turnAround = false
			end
		end
	end
	
	if v.dontMove and v.projectile == 0 then
		v.speedX = 0
		
		local C = 0
		
		if (C == 0 or Player.getNearest(v.x + v.width / 2, v.y + v.height) ~= nil) then
			C = Player.getNearest(v.x + v.width / 2, v.y + v.height)
			if v.x + (v.width / 2) > C.x + (C.width / 2) then
				v.direction = -1
			else
				v.direction = 1
			end
		end
	end
	
	if v.grabbingPlayer == nil then
		if not config.nogravity then
			v.speedY = math.min(v.speedY + config.gravity,config.maxgravity)
		end
		
		if config.noblockcollision then
			v.turnAround = false
		end
		
		-- BasicColliders.applySpeedWithCollision(v)
	end


	callSpecialEvent(v,"onActiveNPC")
	callSpecialEvent(v,"onAnimateNPC")
end

local function values(t)
    local i = 0
    return function() i = i + 1 return t[i] end
end

setmetatable(NPC, {__call=function(NPC, idx)
	return NPC[idx] or NPC
end})


local npcMT = {__type = "NPC", __index = NPC}

function NPC.spawn(id, x, y, section, respawn, centered)
	local n = {
		__type = "NPC",

		layerName = "",
		attachedLayerName = "",
		
		idx = #NPC + 1,
		id = id or 1,
		isValid = true,
		x = x or 0,
		y = y or 0,
		
		spawnX = x or 0,
		spawnY = y or 0,
		spawnWidth = NPC.config[id].width,
		spawnHeight = NPC.config[id].height,
		spawnSpeedX = 0,
		spawnSpeedY = 0,
		spawnDirection = 0,
		spawnId = id or 1,
		spawnAi1 = 0,
		spawnAi2 = 0,
	
		width = NPC.config[id].width,
		height = NPC.config[id].height,
		direction = 0,
		speedX = 0,
		speedY = 0,
		
		projectile = false,
		cantHurt = 0,

		forcedState = 0, -- also known as "contained within"
		forcedTimer = 0,
		
		offscreenFlag = false,
		offscreenFlag2 = false,
		despawnTimer = 180, -- temp
		
		animationFrame = 0,
		animationTimer = 0,
		isHidden = false,
		
		grabbingPlayer = nil,
		tempBlock = {},
		section = 0,
		
		dontMove = false,
		friendly = false,
		legacyBoss = false,
		msg = "",
		
		ai1 = 0,
		ai2 = 0,
		ai3 = 0,
		ai4 = 0,
		ai5 = 0,
		ai6 = 0,

		turnAround = false,

		underwater = false,
		inQuicksand = false,

		health = NPC.config[id].health or 1,

		killed = 0,

		renderingDisabled = false,
		
		data = {_settings = {_global = { }}},
	}
	Physics.add(n)
	
	setmetatable(n,npcMT)

	BasicColliders.addCollisionProperties(n)
	BasicColliders.addSolidObjectProperties(n)

	
	if n.direction == 0 then
		local t = {
		[1] = -1,
		[2] = 1
		}
		n.direction = t[math.floor(math.random(1,2))]
	end
	
	n.onPhysics = physics
	
	NPC[#NPC + 1] = n
	-- print(inspect(n))
	return n
end

-- NPC harming / killing
local updateRemovalQueue

do
	HARM_TYPE_JUMP = 1
	HARM_TYPE_FROMBELOW = 2
	HARM_TYPE_NPC = 3
	HARM_TYPE_PROJECTILE_USED = 4
	HARM_TYPE_LAVA = 5
	HARM_TYPE_HELD = 6
	HARM_TYPE_TAIL = 7
	HARM_TYPE_SPINJUMP = 8
	HARM_TYPE_VANISH = 9
	HARM_TYPE_SWORD = 10

	HARM_TYPE_OFFSCREEN = HARM_TYPE_VANISH


	function NPC:harm(harmType, damageMultiplier, culprit)
		harmType = harmType or HARM_TYPE_NPC
		damageMultiplier = damageMultiplier or 1


		local config = NPC.config[self.id]

		if config.damageMap[harmType] == nil or damageMultiplier == 0 then
			return
		end


		-- Call the onNPCHarm event and see if it's been cancelled
		local eventObj = {cancelled = false}

		EventManager.callEvent("onNPCHarm", eventObj, self, harmType, culprit, damageMultiplier)
		if eventObj.cancelled then
			return
		end
		EventManager.callEvent("onPostNPCHarm", self, harmType, culprit, damageMultiplier)


		local damage = config.damageMap[harmType]

		self.health = self.health - damage

		if self.health <= 0 then
			self:kill(harmType)
		end
	end


	local npcRemovalQueue = {}

	function NPC:kill(harmType)
		if self.killed == 0 then
			table.insert(npcRemovalQueue,self)
		end

		self.killed = harmType or HARM_TYPE_JUMP
	end


	local function npcKillInternal(self,queuePos)
		-- Call the onNPCKill event and see if it's been cancelled
		local eventObj = {cancelled = false}

		EventManager.callEvent("onNPCKill", eventObj, self, self.killed)
		if eventObj.cancelled then
			return
		end
		EventManager.callEvent("onPostNPCKill", self, self.killed)


		local config = NPC.config[self.id]

		local effect = config.effectMap[self.killed]

		if type(effect) == "number" then
			Effect.spawn(effect,self)
		end


		-- Manual table remove, to update idx fields
		local npcCount = #NPC

		for i = self.idx+1, npcCount do
			local npcHere = NPC[i]

			npcHere.idx = npcHere.idx - 1
			NPC[i-1] = npcHere
		end

		NPC[npcCount] = nil


		self.isValid = false
		self.idx = -1


		table.remove(npcRemovalQueue,queuePos)
	end

	function updateRemovalQueue()
		for i = #npcRemovalQueue, 1, -1 do
			local npc = npcRemovalQueue[i]

			if npc.isValid then
				npcKillInternal(npcRemovalQueue[i],i)
			end
		end
	end
end



function NPC:grab(playerObj, sfx)
	if playerObj.__type ~= "Player" then return end
	
	if sfx ~= nil then
		SFX.play(sfx)
	end
	
	self.grabbingPlayer = playerObj
	playerObj.holdingNPC = self
end

function NPC:ungrab(throw, sfx)
	local p = self.grabbingPlayer
	self.grabbingPlayer = nil
	p.holdingNPC = nil
	
	if throw == true then
		if sfx ~= nil then
			SFX.play(sfx)
		end
	
		self.speedX = 5 * p.direction
		self.speedY = -6
		self.projectile = true
	else
		self.x = p.x + p.width / 2 - self.width / 2
		self.y = p.y + p.height - self.height
		self.x = (self.x + ((p.width + p.width / 4) * p.direction))
		self.speedX = 0
		self.speedY = 0
	end
end

function NPC.count()
	return #NPC
end


-- "Get" functions
do
	function NPC.count()
		return #NPC
	end

	function NPC.get(idFilter)
		local ret = {}

		local idFilterType = type(idFilter)
		local idMap
		if idFilter == "table" then
			idMap = {}

			for _,id in ipairs(idFilter) do
				idMap[id] = true
			end
		end


		for _,v in ipairs(NPC) do
			if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
				ret[#ret + 1] = v
			end
		end

		return ret
	end

	function NPC.getIntersecting(x1,y1,x2,y2)
		local ret = {}

		for _,v in ipairs(NPC) do
			if v.x <= x2 and v.y <= y2 and v.x+v.width >= x1 and v.y+v.height >= y1 then
				ret[#ret + 1] = v
			end
		end

		return ret
	end


	-- Based on the lunalua implementation

	local function iterate(args,i)
		while (i <= args[1]) do
			local v = NPC[i]

			local idFilter = args[2]
			local idMap = args[3]

			if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
				return i+1,v
			end

			i = i + 1
		end
	end

	function NPC.iterate(idFilter)
		local args = {#NPC,idFilter}

		if type(idFilter) == "table" then
			args[3] = {}

			for _,id in ipairs(idFilter) do
				args[3][id] = true
			end
		end

		return iterate, args, 1
	end

	local function iterateIntersecting(args,i)
		while (i <= args[1]) do
			local v = NPC[i]

			if v.x <= args[4] and v.y <= args[5] and v.x+v.width >= args[2] and v.y+v.height >= args[3] then
				return i+1,v
			end

			i = i + 1
		end
	end

	function NPC.iterateIntersecting(x1,y1,x2,y2)
		local args = {#NPC,x1,y1,x2,y2}

		return iterateIntersecting, args, 1
	end
end


function NPC.update()
	updateRemovalQueue()

	for k,v in ipairs(NPC) do
		local scr = NPC.script[v.id]

		if scr ~= nil then
			if scr.onPhysicsNPC ~= nil then scr.onPhysicsNPC(v) else physics(v) end
			if scr.onTickNPC ~= nil then scr.onTickNPC(v) end
			if scr.onTickEndNPC ~= nil then scr.onTickEndNPC(v) end
		else
			physics(v)
		end
	end
end


-- TODO: overhaul this. like, all of it. we don't need a dedicated frames thing.
function NPC.frames()
	for k,v in ipairs(NPC) do
		if(NPC.config[v.id].frames > 0) then
			v.animationTimer = v.animationTimer + 1
			if(NPC.config[v.id].framestyle == 2 and (v.projectile ~= 0 or v.holdingPlayer > 0)) then
				v.animationTimer = v.animationTimer + 1
			end
			if(v.animationTimer >= NPC.config[v.id].framespeed) then
				if(NPC.config[v.id].framestyle == 0) then
					v.animationFrame = v.animationFrame + 1 * v.direction
				else
					v.animationFrame = v.animationFrame + 1
				end
				v.animationTimer = 0
			end
			if(NPC.config[v.id].framestyle == 0) then
				if(v.animationFrame >= NPC.config[v.id].frames) then
					v.animationFrame = 0
				end
				if(v.animationFrame < 0) then
					v.animationFrame = NPC.config[v.id].frames - 1
				end
			elseif(NPC.config[v.id].framestyle == 1) then
				if(v.direction == -1) then
					if(v.animationFrame >= NPC.config[v.id].frames) then
						v.animationFrame = 0
					end
					if(v.animationFrame < 0) then
						v.animationFrame = NPC.config[v.id].frames
					end
				else
					if(v.animationFrame >= NPC.config[v.id].frames * 2) then
						v.animationFrame = NPC.config[v.id].frames
					end
					if(v.animationFrame < NPC.config[v.id].frames) then
						v.animationFrame = NPC.config[v.id].frames
					end
				end
			elseif(NPC.config[v.id].framestyle == 2) then
				if(v.holdingPlayer == 0 and v.projectile == 0) then
					if(v.direction == -1) then
						if(v.animationFrame >= NPC.config[v.id].frames) then
							v.animationFrame = 0
						end
						if(v.animationFrame < 0) then
							v.animationFrame = NPC.config[v.id].frames - 1
						end
					else
						if(v.animationFrame >= NPC.config[v.id].frames * 2) then
							v.animationFrame = NPC.config[v.id].frames
						end
						if(v.animationFrame < NPC.config[v.id].frames) then
							v.animationFrame = NPC.config[v.id].frames * 2 - 1
						end
					end
				else
					if(v.direction == -1) then
						if(v.animationFrame >= NPC.config[v.id].frames * 3) then
							v.animationFrame = NPC.config[v.id].frames * 2
						end
						if(v.animationFrame < NPC.config[v.id].frames * 2) then
							v.animationFrame = NPC.config[v.id].frames * 3 - 1
						end
					else
						if(v.animationFrame >= NPC.config[v.id].frames * 4) then
							v.animationFrame = NPC.config[v.id].frames * 3
						end
						if(v.animationFrame < NPC.config[v.id].frames * 3) then
							v.animationFrame = NPC.config[v.id].frames * 4 - 1
						end
					end
				end
			end
		end
	end
end

return NPC