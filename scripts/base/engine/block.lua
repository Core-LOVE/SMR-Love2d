local Block = {__type="Block"}

Block.config = {}
Block.script = {}
Block.frame = {}
Block.framecount = {}

for i = 1,BLOCK_MAX_ID do
	Block.config[i] = {
		sizeable = false,
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
	}
	Block.frame[i] = 0
	Block.framecount[i] = 0
	
	if love.filesystem.getInfo("scripts/blocks/block-"..tostring(i)..".lua") then
		Block.script[i] = require("scripts/blocks/block-"..tostring(i))
	end
end

local function physics(v)
	if v == nil then return end
	
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
			if not n.isValid or n.grabbingPlayerIndex ~= 0 or 
			(NPC.config[n.id].noblockcollision or not NPC.config[n.id].iscoin) or n.tempBlock == v or
			v.isReally == n or v.shakeY3 > 0 or not NPC.config[n.id].iscoin then break end
			
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

local function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

setmetatable(Block, {__call=function(Block, idx)
	return Block[idx] or Block
end})

function Block.spawn(id, x, y)
	local b = {
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
	print(inspect(b))
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

end

function Block.count()
	return #Block
end

function Block.get(idFilter)
	local ret = {}

	for i = 1, #Block do
		if idFilter == nil then
			ret[#ret + 1] = Block(i)
			print(inspect(Block(i)))
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if Block(i).id == k then
					ret[#ret + 1] = Block(i)
					print(inspect(Block(i)))
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if Block(i).id == k then
						ret[#ret + 1] = Block(i)
						print(inspect(Block(i)))
					end
				end
			end
		end
	end

	return ret
end

function Block:update()
	for k,b in ipairs(Block.get()) do
		b.onPhysicsBlock(b)
		b.onTickEndBlock(b)
		b.onTickBlock(b)
	end
end

return Block