local Window = {__type = "Window"}
Window.__index = Window

local function hex(hex, alpha)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)) / 255, tonumber("0x"..hex:sub(3,4)) / 255, tonumber("0x"..hex:sub(5,6)) / 255, alpha
end

local function checkMouse(x,y,w,h)
	if love.mouse.getX() >= x and
	love.mouse.getY() >= y and
	love.mouse.getX() <= x + w and
	love.mouse.getY() <= y + h then
		return true
	end
	
	return false
end

function Window.new()
   local w = {x = 0, y = 0, width = 100, height = 100, canClose = true, dx = 0, dy = 0}
   w.resize = 0
   w.minX, w.minY = 0, 0
   w.maxX, w.maxY = love.graphics.getWidth(), love.graphics.getHeight()
   
   setmetatable(w, Window)
   
   return w
end

local function draw_buttons(v)
	love.graphics.setColor(1,1,1,v.alpha)
	if v.canClose and v.closebutton ~= nil then
		local img = v.closebutton
		
		local x,y,w,h = v.realX + (v.width - (img:getWidth() + 8)), v.realY + 1, img:getWidth(), img:getHeight()
		
		if checkMouse(x,y,w,h) and v.isMoving then
			v.q:setViewport(0, 20, img:getWidth(), 20, img:getDimensions())
			
			if love.mouse.isDown(1) then
				v.q:setViewport(0, 40, img:getWidth(), img:getHeight() / 3, img:getDimensions())
				v.isMoving = false
				v.isClosed = true
			end
		else
			v.q:setViewport(0, 0, img:getWidth(), img:getHeight() / 3, img:getDimensions())
		end
		
		love.graphics.draw(img, v.q, x, y)
	end
end

local function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

local function draw_up(v)
	draw_buttons(v)
	
	if v.icon_img ~= nil then
		love.graphics.draw(v.icon_img, v.realX + 8, v.realY + 8)
	end
	
	if v.name ~= nil then
		love.graphics.setColor(0,0,0,v.alpha or 1)
		love.graphics.print(v.name, v.realX + 28, v.realY + 8)
	end
end

local function draw_border(v, c1, c2)
	local col = v.color or {0,0,0, v.alpha or 1}
	col[4] = v.alpha
	
	love.graphics.setColor(col)
	
	love.graphics.rectangle('fill', v.realX + 8, v.realY + 32, v.width - 16, v.height - 40)
	
	love.graphics.setColor(hex(c1, v.alpha or 1))
	
	love.graphics.rectangle('fill', v.realX, v.realY, 8, v.height)
	love.graphics.rectangle('fill', v.realX + v.width - 8, v.realY, 8, v.height)
	love.graphics.rectangle('fill', v.realX + 8, v.realY + v.height - 8, v.width - 16, 8)
	love.graphics.rectangle('fill', v.realX + 8, v.realY, v.width - 16, 32)
	
	love.graphics.setColor(hex(c2, v.alpha or 1))
	
	love.graphics.rectangle('line', v.realX, v.realY, v.width, v.height)
	love.graphics.rectangle('line', v.realX + 8, v.realY + 32, v.width - 16, v.height - 40)
end

function Window:draw(v)
	draw_border(v, 'EF8383', 'B76464')
	draw_up(v)
	
	if v.contentDraw ~= nil then
		love.graphics.setCanvas(v.canvas)
		love.graphics.clear()	
		
		v:contentDraw()
		
		love.graphics.setCanvas(nil)
	end
	
	love.graphics.setColor(1,1,1,v.alpha)
	love.graphics.draw(v.canvas, v.realX + 8, v.realY + 32)
end

function Window:update(v)
	v.x = v.realX + 8
	v.y = v.realY + 32
	
	if (not love.mouse.isDown(1) and v.isMoving) then 
		v.isMoving = false 
		v.isClosed = false
		v.dx = 0
		v.dy = 0
	end
	
	if (not love.mouse.isDown(1) and v.resize ~= 0) then 
		v.resize = 0
		v.dx = 0
		v.dy = 0
	end
	
	if not love.mouse.isDown(1) and v.isClosed then
		if v.close ~= nil then v.close() end
		v:remove()
	end
	
	if love.mouse.isDown(1) and not v.isMoving and not v.isClosed and v.resize == 0 then
		local x1, y1, w1, h1 = v.realX, v.realY, 8, v.height
		local x2, y2, w2, h2 = v.realX + v.width - 8, v.realY, 8, v.height
		local x3, y3, w3, h3 = v.realX, v.realY + v.height - 8, v.width, 8
		local x4, y4, w4, h4 = v.realX, v.realY, v.width, 32
		
		if checkMouse(x4 + 8, y4 + 8, w4 - 8, h4 - 8) then
			v.dx = love.mouse.getX() - v.realX
			v.dy = love.mouse.getY() - v.realY
			v.isMoving = true
		end
		
		if checkMouse(x4 + 8, y4, w4 - 8, 8) then
			v.dx = love.mouse.getX() - v.realX
			v.dy = love.mouse.getY() - v.realY
			
			v.resize = -2
		end
	end
	
	if v.isMoving then
		v.realX = love.mouse.getX() - v.dx
		v.realY = love.mouse.getY() - v.dy
	end
	
	if resize == -2 then
		v.realY = love.mouse.getY() - v.dy
		v.realX = 0
	end
end

return Window