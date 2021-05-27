local txt_parser = require("txt_parser")
local blockConfig = {}

local properties = {
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
}

local mt = {}
local internal = {}

function mt.__index(self, id)
	if not internal[id] then
		internal[id] = {}
		
		local path = "config/npc/npc-".. id.. ".txt"

		if love.filesystem.getInfo(path) then
			local parsed = txt_parser.load(path)
			
			for k,v in pairs(parsed) do
				internal[id][k] = v
			end
		end
		
		setmetatable(internal[id], {__index = function(t, key)
			return properties[key]
		end})
	end
	
	return internal[id]
end

setmetatable(blockConfig, mt)

return blockConfig