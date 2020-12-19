io = {}

io.open = function(file, mode)
	return love.filesystem.newFile(file, mode or "r")
end

io.close = function(file)
	return file:close()
end