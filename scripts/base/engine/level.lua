local Level = {}

local worldLevel = {__type = "Level"}

local LevelParser = require("engine/Levelparser")

function Level.filename()
	return LevelFileName
end

function Level.name()
	return LevelName
end

function Level.exit()
	
end

function Level.winState(value)
	if value == nil then
		return LevelMacro
	else
		LevelMacro = value or 0
	end
end

function Level.winTimer(value)
	if value == nil then
		return LevelMacroCounter
	else
		LevelMacroCounter = value or 0
	end
end

function Level.load(LevelFilename, episodeFolderName, warpIndex)
	LevelParser.load(LevelFilename)
end

function Level.loadPlayerHitBoxes(characterId, powerUpId, iniFilename)

end

-- Class

function Level.spawn(id, x, y)
	local t = {
		idx = #Level + 1,
		isValid = true,
		
		id = id or 1,
		x = x or 0,
		y = y or 0,
		isHidden = false,
		
		filename = "",
		
		width = 32,
		height = 32,
	}
	setmetatable(t, {__type = worldLevel.__type, __index = worldLevel})
	
	Level[#Level + 1] = t
	return t
end

function Level.get(idFilter)
	local ret = {}

	local idFilterType = type(idFilter)
	local idMap
	if idFilter == "table" then
		idMap = {}

		for _,id in ipairs(idFilter) do
			idMap[id] = true
		end
	end


	for _,v in ipairs(Level) do
		if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
			ret[#ret + 1] = v
		end
	end

	return ret
end

function Level.getIntersecting(x1,y1,x2,y2)
	local ret = {}

	for _,v in ipairs(Level) do
		if v.x <= x2 and v.y <= y2 and v.x+v.width >= x1 and v.y+v.height >= y1 then
			ret[#ret + 1] = v
		end
	end

	return ret
end

do
	local function iterate(args,i)
		while (i <= args[1]) do
			local v = Level[i]

			local idFilter = args[2]
			local idMap = args[3]

			if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
				return i+1,v
			end

			i = i + 1
		end
	end

	function Level.iterate(idFilter)
		local args = {#Level,idFilter}

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
			local v = Level[i]

			if v.x <= args[4] and v.y <= args[5] and v.x+v.width >= args[2] and v.y+v.height >= args[3] then
				return i+1,v
			end

			i = i + 1
		end
	end

	function Level.iterateIntersecting(x1,y1,x2,y2)
		local args = {#Level,x1,y1,x2,y2}

		return iterateIntersecting, args, 1
	end
end
	
function Level.count()
	return #Level
end

setmetatable(Level, {__call = function(self, idx)
	return Level[idx] or Level
end})

return Level