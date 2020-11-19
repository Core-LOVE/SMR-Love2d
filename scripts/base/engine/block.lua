local Block = {__type="Block"}

Block.config = {}
Block.script = {}
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
	if love.filesystem.getInfo("scripts/blocks/block-"..tostring(i)..".lua") then
		Block.script[i] = require("scripts/blocks/block-"..tostring(i))
	end
end

local BlockFields = {
	idx = 0,
	id = 1,
	contentID = 0,
	isValid = false,
	uid = nil,
	pid = nil,
	pidIsDirty = nil,
	lightSource = nil,
	speedX = 0,
	speedY = 0,
	x = 0,
	y = 0,
	isHidden = false,
	slippery = false,
	layerObj = "",
	layerName = "",
	
	width = 32,
	height = 32,
	isSizeable = false,
}

local function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

setmetatable(Block, {__call=function(Block, idx)
	return Block[idx] or Block
end})

function Block.spawn(id, x, y)
	local b = {}
	
	for k,v in pairs(BlockFields) do
		b[k] = v
	end
	b.idx = #Block + 1
	b.id = id or 1
	b.x = x or 0
	b.y = y or 0
	b.width = Block.config[id].width or 32
	b.height = Block.config[id].height or 32
	b.isSizeable = Block.config[id].sizeable or false
	b.isValid = true
	
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

return Block