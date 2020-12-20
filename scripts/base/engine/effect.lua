local Effect = {__type="Effect"}


EFFECT_MAX_ID = 1000


Effect.config = {}
Effect.script = {}
for i = 1, EFFECT_MAX_ID do
	Effect.config[i] = {
		xOffset = 0,
		yOffset = 0,
		gravity = 0,
		lifetime = 65,
		delay = 0,
		
		frames = 1,
		framestyle = 0,
		framespeed = 8,
		
		animationFrame = 0,
		animationTimer = 0,
		
		sound = nil,
		
		-- priority = enum_priority.FOREGROUND,
		
		-- xAlign = enum_align.LEFT,
		-- yAlign = enum_align.TOP,
		
		-- spawnBindX = enum_align.LEFT,
		-- spawnBindY = enum_align.TOP,
		
		speedX = 0,
		speedY = 0,
		
		maxSpeedX=-1,
		maxSpeedY=-1,
		
		opacity = 1,
		
		direction = -1,
		
		npcID = 0,
		
		angle = 0,
		rotation = 0,
		
		variants = 1,
		variant = 1,
		frameOffset = 0
	}
	-- if love.filesystem.getInfo("scripts/effects/effect-"..tostring(i)..".lua") then
		-- Effect.script[i] = require("scripts/effect/effect-"..tostring(i))
	-- end
	if love.filesystem.getInfo("config/effect/effect-"..tostring(i)..".txt") then
		local Txt = txt_parser.load("config/effect/effect-"..tostring(i)..".txt")
		for k,v in pairs(Txt) do
			Effect.config[i][k] = v
		end
	end	
end

function Effect:remove(npcID)
	local v = Effect[self.idx]
	local n
	
	if npcID ~= nil and npcID > 0 and type(npcID) == 'number' then
		n = NPC.spawn(npcID, v.x + (v.width / 2), v.y - 1)
		n.x = n.x - (n.width / 2)
	end
	Effect[self.idx] = nil
	
	collectgarbage()
	return v,n
end

local function physics(v)
	v.lifetime = v.lifetime - 1
	if v.lifetime <= 0 then
		v:remove(v.npcID)
		SFX.play(1)
	end
end

local function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

setmetatable(Effect, {__call=function(Effect, idx)
	return Effect[idx] or Effect
end})

function Effect.spawn(id, x, y, variant)
	local b = {
		isValid = true,
		idx = #Effect + 1,
		id = id or 1,
		x = x or 0,
		y = y or 0,
		width = 32,
		height = 32,
		animationFrame = 0,
		animationTimer = 0,
		direction = 0,
	}
	for k in ipairs(Effect.config[b.id]) do
		b[k] = Effect.config[b.id][k]
	end
	b.variant = variant or 1
	
	Effect[#Effect + 1] = b
	print(inspect(b))
	return b
end

function Effect.count()
	return #Effect
end

function Effect.get(idFilter)
	local ret = {}

	local idFilterType = type(idFilter)
	local idMap
	if idFilter == "table" then
		idMap = {}

		for _,id in ipairs(idFilter) do
			idMap[id] = true
		end
	end

	for _,v in ipairs(Effect) do
		if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
			ret[#ret + 1] = v
		end
	end

	return ret
end

function Effect.getIntersecting(x1,y1,x2,y2)
	local results = {}
	
	for k,v in ipairs(Effect) do
		local leftEdge = v.x - v.width * Effect.config[v.id].xAlign
		local topEdge = v.y - v.height * Effect.config[v.id].yAlign
		if leftEdge > x1
		and leftEdge + v.width < x2
		and topEdge > y1
		and topEdge + v.height < y2
			then
			tableinsert(results, v)
		end
	end
	
	return results
end

function Effect.update()
	for k,v in ipairs(Effect) do
		physics(v)
	end
end

function Effect.frames()
	--WIP!!
	for k,v in ipairs(Effect) do
		if(Effect.config[v.id].frames > 0) then
			v.animationTimer = v.animationTimer + 1
			if(Effect.config[v.id].framestyle == 2 and (v.projectile ~= 0)) then
				v.animationTimer = v.animationTimer + 1
			end
			if(v.animationTimer >= Effect.config[v.id].framespeed) then
				if(Effect.config[v.id].framestyle == 0) then
					v.animationFrame = v.animationFrame + 1 * v.direction
				else
					v.animationFrame = v.animationFrame + 1
				end
				v.animationTimer = 0
			end
			if(Effect.config[v.id].framestyle == 0) then
				if(v.animationFrame >= Effect.config[v.id].frames) then
					v.animationFrame = 0
				end
				if(v.animationFrame < 0) then
					v.animationFrame = Effect.config[v.id].frames - 1
				end
			elseif(Effect.config[v.id].framestyle == 1) then
				if(v.direction == -1) then
					if(v.animationFrame >= Effect.config[v.id].frames) then
						v.animationFrame = 0
					end
					if(v.animationFrame < 0) then
						v.animationFrame = Effect.config[v.id].frames
					end
				else
					if(v.animationFrame >= Effect.config[v.id].frames * 2) then
						v.animationFrame = Effect.config[v.id].frames
					end
					if(v.animationFrame < Effect.config[v.id].frames) then
						v.animationFrame = Effect.config[v.id].frames
					end
				end
			elseif(Effect.config[v.id].framestyle == 2) then
				if(v.holdingPlayer == 0 and v.projectile == 0) then
					if(v.direction == -1) then
						if(v.animationFrame >= Effect.config[v.id].frames) then
							v.animationFrame = 0
						end
						if(v.animationFrame < 0) then
							v.animationFrame = Effect.config[v.id].frames - 1
						end
					else
						if(v.animationFrame >= Effect.config[v.id].frames * 2) then
							v.animationFrame = Effect.config[v.id].frames
						end
						if(v.animationFrame < Effect.config[v.id].frames) then
							v.animationFrame = Effect.config[v.id].frames * 2 - 1
						end
					end
				else
					if(v.direction == -1) then
						if(v.animationFrame >= Effect.config[v.id].frames * 3) then
							v.animationFrame = Effect.config[v.id].frames * 2
						end
						if(v.animationFrame < Effect.config[v.id].frames * 2) then
							v.animationFrame = Effect.config[v.id].frames * 3 - 1
						end
					else
						if(v.animationFrame >= Effect.config[v.id].frames * 4) then
							v.animationFrame = Effect.config[v.id].frames * 3
						end
						if(v.animationFrame < Effect.config[v.id].frames * 3) then
							v.animationFrame = Effect.config[v.id].frames * 4 - 1
						end
					end
				end
			end
		end
	end
end

return Effect