local NPC = {__type="NPC"}


NPC_MAX_ID = 1000


NPC.config = {}
NPC.script = {}
for i = 1,NPC_MAX_ID do
	NPC.config[i] = {
		gfxoffsetx=0,
		gfxoffsety=2,
		width=32,
		height=32,
		gfxwidth=32,
		gfxheight=32,
		frames = 2,
		framespeed = 8,
		framestyle = 0,
		noblockcollision = false,

		playerblock=false,
		playerblocktop=false,
		npcblock=false,
		npcblocktop=false,

		score = 2,
		
		grabside=false,
		grabtop=false,

		jumphurt=false,
		nohurt=false,

		noblockcollision=false,
		cliffturn=false,
		noyoshi=false,

		foreground=false,
		priority = nil,
		
		nofireball=false,
		noiceball=false,
		nogravity=false,

		harmlessgrab=false,
		harmlessthrown=false,
		spinjumpsafe=false,

		isshell=false,
		isinteractable=false,
		iscoin=false,
		isvine=false,
		isplant=false,
		iscollectablegoal=false,
		isflying=false,
		iswaternpc=false,
		isshoe=false,
		isyoshi=false,
		isbot=false,
		isvegetable=false,
		iswalker=false,
		
		gravity = Defines.npc_grav,
		maxgravity = 8,
	}
	if love.filesystem.getInfo("scripts/npc/npc-"..tostring(i)..".lua") then
		NPC.script[i] = require("scripts/npcs/npc-"..tostring(i))
	end
	
	
	if love.filesystem.getInfo("config/npc/npc-"..tostring(i)..".txt") then
		local Txt = txt_parser.load("config/npc/npc-"..tostring(i)..".txt")
		for k,v in pairs(Txt) do
			NPC.config[i][k] = v
		end
	end
end

local function physics(v)
	--[[local oldSlope = 0
	local HitSpot = 0 --used for collision detection
	local tempHit = 0
	local tmpBlock = {}
	local tempHitBlock = 0
	local tempSpeedA = 0
	local tempTurn = false
	local tempLocation = newLocation()
	local tempLocation2 = newLocation()
	local preBeltLoc = newLocation()
	local beltCount = 0
	local tempBlockHit = {[3] = 0}
	local winningBlock = 0
	local numTempBlock = 0
	local speedVar = 0
	
	local tempBool = false
	local newY = 0
	local blankBlock = {}
	local oldBeltSpeed = 0
	local oldDirection = 0
	
	--used for collision detection
	local fBlock = 0
	local lBlock = 0
	local fBlock2 = 0
	local lBlock2 = 0
	local bCheck = 0
	local bCheck2 = 0
	local addBelt = 0
	local numAct = 0
	local beltClear = false --stops belt movement when on a wall
	local resetBeltSpeed = false
	local PlrMid = 0
	local Slope = 0
	local SlopeTurn = false
	
	--for attaching to layers
	local lyrX = 0
	local lyrY = 0
	
	if not Defines.levelFreeze then
		v.x = v.x + v.speedX
		v.y = v.y + v.speedY
		
		for k,b in ipairs(Block) do
			if not BasicColliders.check(b,v) then 
				v.collidesBlockSide = 5
				
				if not NPC.config[v.id].nogravity and NPC.config[v.id].gravity ~= 0 then
					v.speedY = v.speedY + NPC.config[v.id].gravity
					if v.speedY > NPC.config[v.id].maxgravity then
						v.speedY = NPC.config[v.id].maxgravity
					end
				end
			else
				if BasicColliders.side(v,b) == 1 then v.collidesBlockBottom = true else v.collidesBlockBottom = false end
				if BasicColliders.side(v,b) == 3 then v.collidesBlockTop = true else v.collidesBlockTop = false end
				if BasicColliders.side(v,b) == 2 then v.collidesBlockLeft = true else v.collidesBlockLeft = false end
				if BasicColliders.side(v,b) == 4 then v.collidesBlockRight = true else v.collidesBlockRight = false end
				
				v.collidesBlockSide = BasicColliders.side(v,b)
			
				if v.y + v.height + 0.1 > b.y then
					v.speedY = 0
					v.y = b.y - v.height - 0.1
					break
				end
			end
		end
		
		v.speedX = NPC.config[v.id].const_speed * v.direction
	end]]

	local config = NPC.config[v.id]

	if v.turnAround then
		v.direction = -v.direction
		v.turnAround = false
	end

	if config.iswalker then
		v.speedX = Defines.npc_walkingspeed * v.direction
	end

	v.speedY = math.min(v.speedY + config.gravity,config.maxgravity)

	-- temp
	if love.keyboard.isDown("a") then
		v.speedY = -4
	end

	BasicColliders.applySpeedWithCollision(v)
end

local function values(t)
    local i = 0
    return function() i = i + 1 return t[i] end
end

setmetatable(NPC, {__call=function(NPC, idx)
	return NPC[idx] or NPC
end})


local npcMT = {__type = "NPC"}

function NPC.spawn(id, x, y)
	local n = {
		__type = "NPC",


		idx = #NPC + 1,
		id = id or 1,
		isValid = true,
		x = x or 0,
		y = y or 0,
		
		spawnX = x or 0,
		spawnY = y or 0,
		spawnWidth = NPC.config[id].width or 32,
		spawnHeight = NPC.config[id].height or 32,
		spawnSpeedX = 0,
		spawnSpeedY = 0,
		spawnDirection = 0,
		spawnId = id or 1,
		spawnAi1 = 0,
		spawnAi2 = 0,
	
		width = NPC.config[id].width or 32,
		height = NPC.config[id].height or 32,
		direction = 0,
		speedX = 0,
		speedY = 0,
		projectile = false,
		
		holdingPlayer = 0,
		projectile = 0,
		
		offscreenFlag = false,
		offscreenFlag2 = false,
		despawnTimer = 0,
		
		animationFrame = 0,
		animationTimer = 0,
		isHidden = false,
		
		grabbingPlayerIndex = 0,
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
	}

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
	print(inspect(n))
	return n
end

function NPC:harm(harmType, damage, reason)

end

function NPC.count()
	return #NPC
end

function NPC.get(idFilter)
	local ret = {}

	for i = 1, #NPC do
		if idFilter == nil then
			ret[#ret + 1] = NPC(i)
			print(inspect(NPC(i)))
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if NPC(i).id == k then
					ret[#ret + 1] = NPC(i)
					print(inspect(NPC(i)))
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if NPC(i).id == k then
						ret[#ret + 1] = NPC(i)
						print(inspect(NPC(i)))
					end
				end
			end
		end
	end

	return ret
end

function NPC.update()
	for k,v in ipairs(NPC) do
		v.onPhysics(v)
	end
end

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