local LTP = {}

function LTP.load(fileName)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.')
	local lovefile = love.filesystem.newFile(fileName)
	local file = assert(lovefile:open('r'), 'Error loading file : ' .. fileName)
	local data = {}

	for line in love.filesystem.lines(fileName) do
		local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$');
		if(param and value ~= nil)then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			data[param] = value;
		end
	end

	lovefile:close()
	return data
end

return LTP