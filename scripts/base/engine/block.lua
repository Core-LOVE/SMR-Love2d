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
	isValid = false,

	uid = nil,
	pid = nil,
	pidIsDirty = nil,

	lightSource = nil,

	x = 0,
	y = 0,
	width = 32,
	height = 32,
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
	
	b.idx = #Block + 1
	b.id = id or 1
	b.x = x or 0
	b.y = y or 0
	b.isValid = true
	
	Block[#Block + 1] = b
	print("BLOCK.SPAWN() - IDX: "..b.idx.."; ID: "..b.id.."; X: "..b.x.."; Y: "..b.y)
	return b
end

function Block.count()
	return #Block
end

function Block.get(idFilter)
	local ret = {}

	for i = 1, #Block do
		if idFilter == nil then
			ret[#ret + 1] = Block(i)
			print("BLOCK.GET() - IDX: "..i)
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if Block(i).id == k then
					ret[#ret + 1] = Block(i)
					print("BLOCK.GET("..k..") - IDX: "..i.."; ID: "..k)
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if Block(i).id == k then
						ret[#ret + 1] = Block(i)
						print("BLOCK.GET(idFilter["..k.."]) - IDX: "..i.."; ID: "..k)
					end
				end
			end
		end
	end

	return ret
end

return Block