local Credits = {}

setmetatable(Credits, {__call = function(Credits, idx)
	return Credits[idx] or Credits
end})

return Credits