local Window = {__type="Window"}

setmetatable(Window, {__call=function(Window, idx)
	return Window[idx] or Window
end})

return Window