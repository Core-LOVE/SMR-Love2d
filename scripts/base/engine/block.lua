-- TODO:
-- Sorted block array to increase speed
-- Better config implementation, maybe as a separate library

local Block = {__type="Block"}


BLOCK_MAX_ID = 1000


Block.config = {}
Block.script = {}
Block.frame = {}
Block.framecount = {}


Block.bumped = {}
setmetatable(Block.bumped, {__call = function(self)
	local ret = {}
	
	for k,v in ipairs(self) do
		table.insert(self, v)
	end
	
	return ret
end})


for i = 1,BLOCK_MAX_ID do
	Block.config[i] = {
		sizable = false,
		connecting = false,
		playerpassthrough = false,
		npcpassthrough = false,
		passthrough = false,
		floorslope = 0,
		ceilingslope = 0,
		width = 32,
		height = 32,
		semisolid = false,
		lava = false,
		bumpable = false,
		smashable = false,
		destroyeffect = 1,
		explodable = false,
		hammer = false,
		noicebrick = false,
		bounceside = false,
		diggable = false,
		frames = 1,
		framespeed = 8,
		foreground = false,
		priority = nil,
	}
	Block.frame[i] = 0
	Block.framecount[i] = 0
	
	if love.filesystem.getInfo("scripts/blocks/block-"..tostring(i)..".lua") then
		Block.script[i] = require("scripts/blocks/block-"..tostring(i))
	end
	
	if love.filesystem.getInfo("config/block/block-"..tostring(i)..".txt") then
		local BlockTxt = txt_parser.load("config/block/block-"..tostring(i)..".txt")
		for k,v in pairs(BlockTxt) do
			Block.config[i][k] = v
		end
	end
end

local function physics(v)
	if v.isHidden then
		v.shakeX = 0
		v.shakeY = 0
		v.shakeX2 = 0
		v.shakeY2 = 0
		v.shakeX3 = 0
		v.shakeY3 = 0
	end
	
	if v.shakeY < 0 then
		v.shakeY = v.shakeY + 2
		v.shakeY3 = v.shakeY3 - 2
		if v.shakeY == 0 then
			if v.triggerHit ~= "" then
			
			end
		end
	elseif v.shakeY > 0 then
		v.shakeY = v.shakeY - 2
		v.shakeY3 = v.shakeY3 + 2
		if v.shakeY == 0 then
			if v.triggerHit ~= "" then
			
			end
		end
	elseif v.shakeY2 > 0 then
		v.shakeY2 = v.shakeY2 - 2
		v.shakeY3 = v.shakeY3 + 2
		if v.rapidHit > 0 and v.ai1 > 0 and v.shakeY3 == 0 then
			v:hit()
			v.rapidHit = v.rapidHit - 1
		end
	elseif v.shakeY2 < 0 then
		v.shakeY2 = v.shakeY2 + 2
		v.shakeY3 = v.shakeY3 - 2
	end
	
	if v.shakeX < 0 then
		v.shakeX = v.shakeX + 2
		v.shakeX3 = v.shakeX3 - 2
		if v.shakeX == 0 then
			if v.triggerHit ~= "" then
			
			end
		end
	elseif v.shakeX > 0 then
		v.shakeX = v.shakeX - 2
		v.shakeX3 = v.shakeX3 + 2
		if v.shakeX == 0 then
			if v.triggerHit ~= "" then
			
			end
		end
	elseif v.shakeX2 > 0 then
		v.shakeX2 = v.shakeX2 - 2
		v.shakeX3 = v.shakeX3 + 2
		if v.rapidHit > 0 and v.ai1 > 0 and v.shakeX3 == 0 then
			v:hit()
			v.rapidHit = v.rapidHit - 1
		end
	elseif v.shakeX2 < 0 then
		v.shakeX2 = v.shakeX2 + 2
		v.shakeX3 = v.shakeX3 - 2
	end
	
	if v.shakeY3 ~= 0 then
		for _,n in ipairs(NPC.get()) do
		
			if n.isValid and n.grabbingPlayerIndex == 0 and
			not NPC.config[n.id].noblockcollision and n.tempBlock ~= v and
			v.isReally ~= n and v.shakeY3 == 0 and NPC.config[n.id].iscoin then
			
				if not Block.config[v.id].sizeable and not Block.config[v.id].semisolid then
					n:harm(2, 1, v)
				else
					if v.y + 1 >= n.y + n.height - 1 then
						n:harm(2, 1, v)
					end
				end
			
			end
			
		end
	end
end


setmetatable(Block, {__call=function(Block, idx)
	return Block[idx] or Block
end})


local blockMT = {
	__type = "Block",
	__index = Block
}

function Block.spawn(id, x, y)
	local b = {
		__type = "Block",
		
		idx = #Block + 1,
		id = id or 1,
		contentID = 0,
		isValid = true,
		uid = nil,
		pid = nil,
		pidIsDirty = nil,
		lightSource = nil,
		speedX = 0,
		speedY = 0,
		x = x or 0,
		y = y or 0,
		
		isHidden = false,
		slippery = false,
		hiddenUntilHit = false, -- invisible editor field
		layerObj = "",
		layerName = "",
		
		isReally = {},
		
		width = Block.config[id].width or 32,
		height = Block.config[id].height or 32,
		isSizeable = Block.config[id].sizeable or false,
		
		shakeX = 0,
		shakeY = 0,
		shakeX2 = 0,
		shakeY2 = 0,
		shakeX3 = 0,
		shakeY3 = 0,
		
		triggerHit = "",
		rapidHit = 0,
		
		ai1 = 0,
		ai2 = 0,
		ai3 = 0,
		ai4 = 0,
		ai5 = 0,
		ai6 = 0
	}
	local c = Block.config[b.id]
	
	-- if c.floorslope ~= 0 or c.ceilingslope ~= 0 then
		-- local concept = {
			-- 1,1, 
			-- 0,1, 
			-- 0,0,
			-- 1,0
		-- }
		
		-- local t = {
			-- b.x + b.width,			b.y + b.height,
			-- b.x,					b.y + b.height,
			-- b.x,					b.y,
			-- b.x + b.width,			b.y,
		-- }
	
		-- Physics.add(b, 'static', 'Polygon', t)
	-- else
		Physics.add(b, 'static')
	-- end
	
	setmetatable(b,blockMT)

	b.onPhysicsBlock = physics
	b.onTickEndBlock = function(b) end
	b.onTickBlock = function(b) end
	
	if Block.script[b.id] ~= nil then
		local s = Block.script[b.id]
		
		if s.onPhysicsBlock ~= nil then
			b.onPhysicsBlock = s.onPhysicsBlock
		end
		
		if s.onTickEndBlock ~= nil then
			b.onTickEndBlock = s.onTickEndBlock
		end
		
		if s.onTickBlock ~= nil then
			b.onTickBlock = s.onTickBlock
		end
	end
	
	Block[#Block + 1] = b
	--print(inspect(b))
	return b
end

function Block:translate(dx, dy)
	if dx == 0 and dy == 0 then
		return self
	end
	self.x = self.x + dx
	self.y = self.y + dy
end

function Block:hit(fromUpperSide, plr, hittingCount)
	

	table.insert(Block.bumped, self)
end


-- "Get" functions
do
	function Block.count()
		return #Block
	end

	function Block.get(idFilter)
		local ret = {}

		local idFilterType = type(idFilter)
		local idMap
		if idFilter == "table" then
			idMap = {}

			for _,id in ipairs(idFilter) do
				idMap[id] = true
			end
		end


		for _,v in ipairs(Block) do
			if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
				ret[#ret + 1] = v
			end
		end

		return ret
	end

	function Block.getIntersecting(x1,y1,x2,y2)
		local ret = {}

		for _,v in ipairs(Block) do
			if v.x < x2 and v.y < y2 and v.x+v.width > x1 and v.y+v.height > y1 then
				ret[#ret + 1] = v
			end
		end

		return ret
	end


	-- Based on the lunalua implementation

	local function iterate(args,i)
		while (i <= args[1]) do
			local v = Block[i]

			local idFilter = args[2]
			local idMap = args[3]

			if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
				return i+1,v
			end

			i = i + 1
		end
	end

	function Block.iterate(idFilter)
		local args = {#Block,idFilter}

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
			local v = Block[i]

			if v.x < args[4] and v.y < args[5] and v.x+v.width > args[2] and v.y+v.height > args[3] then
				return i+1,v
			end

			i = i + 1
		end
	end

	function Block.iterateIntersecting(x1,y1,x2,y2)
		local args = {#Block,x1,y1,x2,y2}

		return iterateIntersecting, args, 1
	end
end



function Block.update()
	for k,b in ipairs(Block.bumped()) do
		b.onPhysicsBlock(b)
		-- b.onTickEndBlock(b)
		-- b.onTickBlock(b)
	end
end

function Block.frames()
	for i = 1, BLOCK_MAX_ID do
		if Block.config[i].framespeed > 0 then

			Block.framecount[i] = Block.framecount[i] + 1
			if Block.framecount[i] >= Block.config[i].framespeed then
				Block.frame[i] = Block.frame[i] + 1
				if Block.frame[i] >= Block.config[i].frames then
					Block.frame[i] = 0
				end
				Block.framecount[i] = 0
			end
			
		end
	end
end

return Block