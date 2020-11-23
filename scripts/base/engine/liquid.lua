local Liquid = {}

setmetatable(Liquid, {__call=function(Liquid, idx)
	return Liquid[idx] or Liquid
end})

function Liquid.create(id, x, y, w, h)
	local l = {
		idx = #Liquid + 1,
		isValid = true,
		
		id = id or 1,
		x = x or 0,
		y = y or 0,
		width = w or 32,
		height = h or 32,
		
		layer = {},
		layerName = "",
		isQuicksand = false,
		
		isHidden = false,
		speedX = 0,
		speedY = 0
	}
	
	if l.id == 2 then
		l.isQuicksand = true
	end
	
	Liquid[#Liquid + 1] = l
	return l
end

function Liquid.get(idFilter)
	local ret = {}

	for i = 1, #Liquid do
		if idFilter == nil then
			ret[#ret + 1] = Liquid(i)
		else
			if type(idFilter) == 'number' then
				local k = idFilter
				if Liquid(i).id == k then
					ret[#ret + 1] = Liquid(i)
				end
			elseif type(idFilter) == 'table' then
				for k in values(idFilter) do
					if Liquid(i).id == k then
						ret[#ret + 1] = Liquid(i)
					end
				end
			end
		end
	end

	return ret
end

function Liquid.count()
	return #Liquid
end

return Liquid