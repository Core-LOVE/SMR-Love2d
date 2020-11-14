local graphics = {}
graphics.sprites = {}

function graphics.loadImage(file)
	return love.graphics.newImage(file)
end

function graphics.loadGraphics()
	if ini_parser == nil then return end
	
	local gfx = ini_parser.load("graphics.ini")

	for i = 1, #gfx do
		local v = gfx[i]
		
		graphics.sprites[v.path] = {}
		if v.max ~= nil then
			for n = 1, v.max do
				graphics.sprites[v.path][n] = {}
				graphics.sprites[v.path][n].img = love.graphics.newImage("graphics/"..v.path.."/"..v.path.."-"..tostring(n)..".png")
				print("graphics/"..v.path.."/"..v.path.."-"..tostring(n)..".png")
			end
			_G[v.path:upper().."_MAX_ID"] = v.max
		end
	end
end

return graphics