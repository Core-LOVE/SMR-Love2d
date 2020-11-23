local Layer = {__type = "Layer"}

setmetatable(Layer, {__call=function(Layer, idx)
	return Layer[idx] or Layer
end})

function Layer:stop()
	self.speedX = 0
	self.speedY = 0
end

function Layer:hide(noSmoke)
	self.isHidden = true
end

function Layer:show(noSmoke)
	self.isHidden = false
end

function Layer:toggle(noSmoke)
	self.isHidden = not self.isHidden
end

function Layer.create(name, hidden)
	local l = {
		layerName = name or "",
		isHidden = hidden or false,
		speedX = 0,
		speedY = 0
	}
	
	if type(l.isHidden) == 'number' then
		l.isHidden = true
	end
	
	Layer[#Layer + 1] = l
	return l
end

function Layer.get(idFilter)
	local ret = {}

	for i = 1, #Layer do
		if idFilter == nil then
			ret[#ret + 1] = Layer(i)
		else
			if type(idFilter) == 'string' then
				local k = idFilter
				if Layer(i).layerName == k then
					ret[#ret + 1] = Layer(i)
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if Layer(i).layerName == k then
						ret[#ret + 1] = Layer(i)
					end
				end
			end
		end
	end

	return ret
end

function Layer.count()
	return #Layer
end

return Layer