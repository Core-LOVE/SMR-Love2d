local NPC = {__type="NPC"}

NPC.config = {}
NPC.script = {}
for i = 1,NPC_MAX_ID do
	NPC.config[i] = {
		width = 32,
		height = 32,
		frames = 1,
		framespeed = 8,
	}
	if love.filesystem.getInfo("scripts/npc/npc-"..tostring(i)..".lua") then
		NPC.script[i] = require("scripts/npcs/npc-"..tostring(i))
	end
end

local NPCFields = {
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

setmetatable(NPC, {__call=function(NPC, idx)
	return NPC[idx] or NPC
end})

function NPC.spawn(id, x, y)
	local n = {}
	
	n.idx = #NPC + 1
	n.id = id or 1
	n.x = x or 0
	n.y = y or 0
	n.isValid = true
	
	NPC[#NPC + 1] = n
	print("NPC.SPAWN() - IDX: "..b.idx.."; ID: "..b.id.."; X: "..b.x.."; Y: "..b.y)
	return b
end

function NPC.count()
	return #NPC
end

function NPC.get(idFilter)
	local ret = {}

	for i = 1, #NPC do
		if idFilter == nil then
			ret[#ret + 1] = NPC(i)
			print("NPC.GET() - IDX: "..i)
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if NPC(i).id == k then
					ret[#ret + 1] = NPC(i)
					print("NPC.GET("..k..") - IDX: "..i.."; ID: "..k)
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if NPC(i).id == k then
						ret[#ret + 1] = NPC(i)
						print("NPC.GET(idFilter["..k.."]) - IDX: "..i.."; ID: "..k)
					end
				end
			end
		end
	end

	return ret
end

return NPC