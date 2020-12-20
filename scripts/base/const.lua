local _CONST = {}

const = function(key)
    if _G[key] then
        _CONST[key] = _G[key]
        _G[key] = nil
    else
		error("variable " ..tostring(key) .. " doesn't exist", 2)
	end
end

local meta = {
    __index = _CONST,
    __newindex = function(tbl, key, value)
        if _CONST[key] then
            error([[attempt to assign to const variable ']] .. tostring(key) .. [[']], 2)
        end
        rawset(tbl, key, value)
    end
}

setmetatable(_G, meta)

return _CONST