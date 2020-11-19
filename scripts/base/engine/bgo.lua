local BGO = {__type="BGO"}

BGO.config = {}
BGO.script = {}
for i = 1, BACKGROUND_MAX_ID do
	BGO.config[i] = {
		width = 32,
		height = 32,
		frames = 1,
		framespeed = 8,
	}
	-- if love.filesystem.getInfo("scripts/bgos/background-"..tostring(i)..".lua") then
		-- BGO.script[i] = require("scripts/bgos/background-"..tostring(i))
	-- end
end

local BGOFields = {
	idx = 0,
	isValid = false,
	x = 0,
	y = 0,
	width = 32,
	height = 32,
}

local function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

setmetatable(BGO, {__call=function(BGO, idx)
	return BGO[idx] or BGO
end})

function BGO.spawn(id, x, y)
	local n = {}
	
	n.idx = #BGO + 1
	n.id = id or 1
	n.x = x or 0
	n.y = y or 0
	n.isValid = true
	
	BGO[#BGO + 1] = n
	print("BGO.SPAWN() - IDX: "..b.idx.."; ID: "..b.id.."; X: "..b.x.."; Y: "..b.y)
	return b
end

function BGO.count()
	return #BGO
end

function BGO.get(idFilter)
	local ret = {}

	for i = 1, #BGO do
		if idFilter == nil then
			ret[#ret + 1] = BGO(i)
			print("BGO.GET() - IDX: "..i)
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if BGO(i).id == k then
					ret[#ret + 1] = BGO(i)
					print("BGO.GET("..k..") - IDX: "..i.."; ID: "..k)
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if BGO(i).id == k then
						ret[#ret + 1] = BGO(i)
						print("BGO.GET(idFilter["..k.."]) - IDX: "..i.."; ID: "..k)
					end
				end
			end
		end
	end

	return ret
end

return BGO