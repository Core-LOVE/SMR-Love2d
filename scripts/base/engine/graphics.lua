local Graphics = {}
Graphics.sprites = {}

function Graphics.CaptureBuffer(w,h,settings)
	return love.graphics.newCanvas(w, h, settings)
end

function Graphics.loadImage(file)
	return love.graphics.newImage(file)
end

function Graphics.loadGraphics(skip)
	if ini_parser == nil then return end
	
	local gfx = ini_parser.load("graphics.ini")

	for i = 1, #gfx do
		local v = gfx[i]
		
		Graphics.sprites[v.path] = {}
		if v.max ~= nil then
			_G[v.path:upper().."_MAX_ID"] = v.max
			if skip == false then
				for n = 1, v.max do
					Graphics.sprites[v.path][n] = {}
					Graphics.sprites[v.path][n].img = love.graphics.newImage("graphics/"..v.path.."/"..v.path.."-"..tostring(n)..".png")
					print("graphics/"..v.path.."/"..v.path.."-"..tostring(n)..".png")
				end
			end
		end
		collectgarbage()
	end

	print("Graphics loading finished")
end

function Graphics.loadUi()
	if ini_parser == nil then return end
	
	local gfx = ini_parser.load("graphics_ui.ini")
	
	for key,v in pairs(gfx) do
		Graphics.sprites.hardcoded = {}
		if v.one == nil then
			if v.max ~= nil then
				for n = v.first, v.max do
					local k = tostring(v.key)
					local id = tostring(n)
					Graphics.sprites.hardcoded[k.."-"..id] = {}
					Graphics.sprites.hardcoded[k.."-"..id].img = love.graphics.newImage("graphics/ui/"..key..id..".png")
					print("Graphics.sprites.hardcoded["..k.."-"..id.."] = graphics/ui/"..key..id..".png")
				end
			end
		else
			local k = tostring(v.key)
			local k2 = ""
			if v.key2 ~= nil then k2 = "-"..tostring(v.key2) end
			Graphics.sprites.hardcoded[k..k2] = {}
			Graphics.sprites.hardcoded[k..k2].img = love.graphics.newImage("graphics/ui/"..key..".png")
			print("Graphics.sprites.hardcoded["..k..k2.."] = graphics/ui/"..key..".png")
		end
	end
end

Graphics.drawingQueue = {}

-- Basic rendering functions
do
	local RENDER_PRIORITY_DEFAULT = 0

	function Graphics.newQueuedDraw(args)
		local draw = {}

		draw.internalDrawFunction = args.drawFunction
		draw.priority = args.priority or RENDER_PRIORITY_DEFAULT
		draw.sceneCoords = args.sceneCoords or false

		draw.args = args

		table.insert(Graphics.drawingQueue,draw)

		return draw
	end


	local function drawImageGeneric_internal(args,camera)
		local quad = love.graphics.newQuad(args.sourceX,args.sourceY,args.sourceWidth,args.sourceHeight,args.texture:getDimensions())
		
		local x = args.x
		local y = args.y
		if args.sceneCoords then
			x = x - camera.x
			y = y - camera.y
		end

		love.graphics.draw(args.texture,quad,x,y)
	end


	local function drawImageGeneric(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity,sceneCoords,priority)
		Graphics.newQueuedDraw{
			drawFunction = drawImageGeneric_internal,

			texture = texture,x = x,y = y,
			sourceX = sourceX or 0,sourceY = sourceY or 0,
			sourceWidth = sourceWidth or texture.width,sourceHeight = sourceHeight or texture.height,
			opacity = opacity,priority = priority or RENDER_PRIORITY_DEFAULT,sceneCoords = sceneCoords,
		}
	end

	function Graphics.drawImage(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity)
		if sourceX == nil then
			opacity = sourceX
		end			

		drawImageGeneric(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity,false,RENDER_PRIORITY_DEFAULT)
	end
	function Graphics.drawImageWP(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity,priority)
		if sourceX == nil then
			if sourceY == nil then
				priority = sourceX
			else
				opacity = sourceX
				priority = sourceY
			end
		end

		drawImageGeneric(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity,false,priority)
	end

	function Graphics.drawImageToScene(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity)
		if sourceX == nil then
			opacity = sourceX
		end			

		drawImageGeneric(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity,true,RENDER_PRIORITY_DEFAULT)
	end
	function Graphics.drawImageToSceneWP(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity,priority)
		if sourceX == nil then
			if sourceY == nil then
				priority = sourceX
			else
				opacity = sourceX
				priority = sourceY
			end
		end

		drawImageGeneric(texture,x,y,sourceX,sourceY,sourceWidth,sourceHeight,opacity,true,priority)
	end
end


return Graphics