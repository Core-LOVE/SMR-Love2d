local BGO = {__type="BGO"}

BGO.config = {}
BGO.script = {}
BGO.frame = {}
BGO.framecount = {}

for i = 1, BACKGROUND_MAX_ID do
	BGO.config[i] = {
		width = Graphics.sprites.background[i].img:getWidth(),
		height = Graphics.sprites.background[i].img:getHeight(),
		frames = 1,
		framespeed = 8,
		climbable = false,
		npcclimbable = false,
		foreground = false,
		priority = nil,
		water = false,
		stoponfreeze = false,
	}
	
	BGO.frame[i] = 0
	BGO.framecount[i] = 0
	-- if love.filesystem.getInfo("scripts/bgos/background-"..tostring(i)..".lua") then
		-- BGO.script[i] = require("scripts/bgos/background-"..tostring(i))
	-- end
	
	if love.filesystem.getInfo("config/background/background-"..tostring(i)..".txt") then
		local Txt = txt_parser.load("config/background/background-"..tostring(i)..".txt")
		for k,v in pairs(Txt) do
			BGO.config[i][k] = v
		end
	end
end

local function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

setmetatable(BGO, {__call=function(BGO, idx)
	return BGO[idx] or BGO
end})

function BGO.spawn(id, x, y)
	local n = {
		idx = #BGO + 1,
		id = id or 1,
		x = x or 0,
		y = y or 0,
		width = BGO.config[id].width or 32,
		height = BGO.config[id].height or 32,
		zOffset = 0,
		isValid = true,
		isHidden = false
	}
	
	BGO[#BGO + 1] = n
	print(inspect(n))
	return n
end

function BGO.count()
	return #BGO
end

function BGO.get(idFilter)
	local ret = {}

	for i = 1, #BGO do
		if idFilter == nil then
			ret[#ret + 1] = BGO(i)
			print(inspect(BGO(i)))
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if BGO(i).id == k then
					ret[#ret + 1] = BGO(i)
					print(inspect(BGO(i)))
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if BGO(i).id == k then
						ret[#ret + 1] = BGO(i)
						print(inspect(BGO(i)))
					end
				end
			end
		end
	end

	return ret
end

function BGO.frames()
	for i = 1, BACKGROUND_MAX_ID do
		local config = BGO.config[i]

		if config.frames > 1 and config.framespeed > 0 then
			BGO.framecount[i] = BGO.framecount[i] + 1
			if BGO.framecount[i] >= config.framespeed then
				BGO.frame[i] = BGO.frame[i] + 1
				if BGO.frame[i] >= config.frames then
					BGO.frame[i] = 0
				end
				BGO.framecount[i] = 0
			end
		end
	end
end

return BGO