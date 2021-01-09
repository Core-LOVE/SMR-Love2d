local Tile = {__type = "Tile"}

function Tile.spawn(id, x, y)
	local t = {
		idx = #Tile + 1,
		isValid = true,
		
		id = id or 1,
		x = x or 0,
		y = y or 0,
		isHidden = false,
		
		width = 32,
		height = 32,
	}
	setmetatable(t, {__type = Tile.__type, __index = Tile})
	
	Tile[#Tile + 1] = t
	return t
end

function Tile.get(idFilter)
	local ret = {}

	local idFilterType = type(idFilter)
	local idMap
	if idFilter == "table" then
		idMap = {}

		for _,id in ipairs(idFilter) do
			idMap[id] = true
		end
	end


	for _,v in ipairs(Tile) do
		if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
			ret[#ret + 1] = v
		end
	end

	return ret
end

function Tile.getIntersecting(x1,y1,x2,y2)
	local ret = {}

	for _,v in ipairs(Tile) do
		if v.x <= x2 and v.y <= y2 and v.x+v.width >= x1 and v.y+v.height >= y1 then
			ret[#ret + 1] = v
		end
	end

	return ret
end

do
	local function iterate(args,i)
		while (i <= args[1]) do
			local v = Tile[i]

			local idFilter = args[2]
			local idMap = args[3]

			if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
				return i+1,v
			end

			i = i + 1
		end
	end

	function Tile.iterate(idFilter)
		local args = {#Tile,idFilter}

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
			local v = Tile[i]

			if v.x <= args[4] and v.y <= args[5] and v.x+v.width >= args[2] and v.y+v.height >= args[3] then
				return i+1,v
			end

			i = i + 1
		end
	end

	function Tile.iterateIntersecting(x1,y1,x2,y2)
		local args = {#Tile,x1,y1,x2,y2}

		return iterateIntersecting, args, 1
	end
end
	
function Tile.count()
	return #Tile
end

setmetatable(Tile, {__call = function(self, idx)
	return Tile[idx] or Tile
end})

return Tile