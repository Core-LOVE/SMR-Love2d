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