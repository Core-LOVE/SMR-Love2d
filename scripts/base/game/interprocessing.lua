return function(arg)
	local t = ''

	print("Program name", arg[0])
	print("Arguments:")

	for n,v in ipairs(arg) do
		-- print(n," ",v)
		if (n > 0) then
			t = t .. [[
			]] .. (Base64.encode(v))
		end
	end
	
	love.system.setClipboardText(t)
end