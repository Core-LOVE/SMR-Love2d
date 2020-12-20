function math.clamp(...)
    local s = {...}
    table.sort(s)
    return s[2]
end

function math.lerp(a,b,t) 
	return a + (b-a) * 0.5 * t 
end

function math.sign(n)
	return (n > 0 and 1) or (n == 0 and 0) or -1
end

function math.type(n)
	if type(n) ~= 'number' or n == nil then return end
	
	if n == math.floor(n) then
		return 'integer'
	else
		return 'float'
	end
end

function math.round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function tointeger(x)
    num = tonumber(x)
    return num < 0 and math.ceil(num) or math.floor(num)
end
