local Effect = {__type="Effect"}


EFFECT_MAX_ID = 1000


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

local function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

setmetatable(Effect, {__call=function(Effect, idx)
	return Effect[idx] or Effect
end})

function Effect.spawn(id, x, y)
	local b = {
		isValid = true,
		idx = #Effect + 1,
		id = id or 1,
		x = x or 0,
		y = y or 0,
		width = Effect.config[id].width or 32,
		height = Effect.config[id].height or 32
	}
	
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