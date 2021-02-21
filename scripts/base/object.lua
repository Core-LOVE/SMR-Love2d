local object = {}

local function set(type, p, f)
	p = p or {}
	f = f or {}
	
	local t = {}
	t.__type = type or "Object"
	
	t.spawn = p.spawn or function(id, x, y)
		local o = f
		
		o.idx = #t + 1
		o.isValid = true
		
		o.id = id or 1
		o.x = x or 0
		o.y = y or 0
		
		for k,v in pairs(f) do
			o[k] = v
		end
		
		setmetatable(o, {__type = t.__type, __index = t})
		t[#t + 1] = o
		return o
	end
	
	t.get = p.get or function(idFilter)
		local ret = {}

		local idFilterType = type(idFilter)
		local idMap
		if idFilter == "table" then
			idMap = {}

			for _,id in ipairs(idFilter) do
				idMap[id] = true
			end
		end


		for _,v in ipairs(t) do
			if idFilter == nil or idFilter == -1 or idFilter == v.id or (idMap ~= nil and idMap[v.id]) then
				ret[#ret + 1] = v
			end
		end

		return ret
	end
	
	
	t.getIntersecting = p.getIntersecting or function(x1,y1,x2,y2)
		local ret = {}

		for _,v in ipairs(t) do
			if v.x <= x2 and v.y <= y2 and v.x+v.width >= x1 and v.y+v.height >= y1 then
				ret[#ret + 1] = v
			end
		end

		return ret
	end
	
	setmetatable(t, {__call = function(self, idx)
		return self[idx] or self
	end})
	
	return t
end

return object