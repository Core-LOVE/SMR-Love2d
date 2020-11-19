local Effect = {__type="Effect"}

Effect.config = {}
Effect.script = {}
for i = 1, EFFECT_MAX_ID do
	Effect.config[i] = {
		width = 32,
		height = 32,
		frames = 1,
		framespeed = 8,
	}
	if love.filesystem.getInfo("scripts/effects/effect-"..tostring(i)..".lua") then
		Effect.script[i] = require("scripts/effect/effect-"..tostring(i))
	end
end

local EffectFields = {
	x = 0,
	y = 0,
	width = 32,
	height = 32,
}

local function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

setmetatable(Effect, {__call=function(Effect, idx)
	return Effect[idx] or Effect
end})

function Effect.spawn(id, x, y)
	local b = {}
	
	b.idx = #Effect + 1
	b.id = id or 1
	b.x = x or 0
	b.y = y or 0
	b.isValid = true
	
	Effect[#Effect + 1] = b
	print(inspect(b))
	return b
end

function Effect.count()
	return #Effect
end

function Effect.get(idFilter)
	local ret = {}

	for i = 1, #Effect do
		if idFilter == nil then
			ret[#ret + 1] = Effect(i)
			print(inspect(Effect(i)))
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if Effect(i).id == k then
					ret[#ret + 1] = Effect(i)
					print(inspect(Effect(i)))
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if Effect(i).id == k then
						ret[#ret + 1] = Effect(i)
						print(inspect(Effect(i)))
					end
				end
			end
		end
	end

	return ret
end

return Effect