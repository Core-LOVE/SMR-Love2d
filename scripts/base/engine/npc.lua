local NPC = {__type="NPC"}

NPC.config = {}
NPC.script = {}
for i = 1,NPC_MAX_ID do
	NPC.config[i] = {
		gfxoffsetx=0,
		gfxoffsety=2,
		width=32,
		height=32,
		gfxwidth=32,
		gfxheight=32,
		frames = 1,
		framespeed = 8,
		noblockcollision = false,

		playerblock=false,
		playerblocktop=false,
		npcblock=false,
		npcblocktop=false,

		score = 2,
		
		grabside=false,
		grabtop=false,

		jumphurt=false,
		nohurt=false,

		noblockcollision=false,
		cliffturn=false,
		noyoshi=false,

		foreground=false,
		nofireball=false,
		noiceball=false,
		nogravity=false,

		harmlessgrab=false,
		harmlessthrown=false,
		spinjumpsafe=false,

		isshell=false,
		isinteractable=false,
		iscoin=false,
		isvine=false,
		iscollectablegoal=false,
		isflying=false,
		iswaternpc=false,
		isshoe=false,
		isyoshi=false,
		isbot=false,
		isvegetable=false,
		iswalker=false,
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
	grabbingPlayerIndex = 0,
	tempBlock = {}
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
	
	for k,v in ipairs(NPCFields) do
		n[k] = v
	end
	n.idx = #NPC + 1
	n.id = id or 1
	n.x = x or 0
	n.y = y or 0
	n.isValid = true
	
	NPC[#NPC + 1] = n
	print(inspect(n))
	return b
end

function NPC:harm(harmType, damage, reason)

end

function NPC.count()
	return #NPC
end

function NPC.get(idFilter)
	local ret = {}

	for i = 1, #NPC do
		if idFilter == nil then
			ret[#ret + 1] = NPC(i)
			print(inspect(NPC(i)))
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if NPC(i).id == k then
					ret[#ret + 1] = NPC(i)
					print(inspect(NPC(i)))
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if NPC(i).id == k then
						ret[#ret + 1] = NPC(i)
						print(inspect(NPC(i)))
					end
				end
			end
		end
	end

	return ret
end

return NPC