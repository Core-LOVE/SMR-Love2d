local Camera = {}

Camera.__type = "Camera"

local globalMT = {
    __call = (function(self,key,value)
        if type(key) == "number" then
            return self[key]
        end
    end),
}

setmetatable(Camera,globalMT)


local CameraMT = {
    __type = "Camera",
    __index = Camera,
}

function Camera.create()
    local v = setmetatable({},CameraMT)

    v.x = 0
    v.y = 0

    v.width = 800
    v.height = 600

    v.renderX = 0
    v.renderY = 0

    v.active = true
    v.renderToScreen = false

    v.canvas = love.graphics.newCanvas(v.width,v.height)


    table.insert(Camera,v)

    return v
end

local test
function Camera:draw()
    love.graphics.setCanvas(self.canvas)

    love.graphics.clear()
	
    for _,draw in ipairs(Graphics.drawingQueue) do
        if draw.internalDrawFunction ~= nil then
            draw.internalDrawFunction(draw.args,self)
        end
    end

    love.graphics.setCanvas(nil)

	local p = 0
	if push.scaler ~= 1 then
		p = 0.5
	end
	
    if self.renderToScreen then
        love.graphics.draw(self.canvas,self.renderX + push.x + p,self.renderY + push.y + p, 0, push.scaler)
    end
end

function Camera.getIntersecting(x1,y1, x2,y2)
	if (type(x1) ~= "number") or (type(y1) ~= "number") or (type(x2) ~= "number") or (type(y2) ~= "number") then
		error("Invalid parameters to getIntersecting")
	end
	
	local ret = {}

	for _,v in ipairs(Camera) do
		if x2 > v.x and
		y2 > v.y and
		v.x + v.width > x1 and
		v.y + v.height > y1 then
			ret[#ret + 1] = v
		end
	end
	
	return ret
end

function Camera.update()
	local v = Camera[1]
	local p = Player[1]

	local s = Section(p.section)
	local bd = s.boundary
	
	v.x = (p.x - (v.width * 0.5)) + (p.width * 0.5) * 2
	v.y = (p.y - (v.height * 0.5)) + (p.height * 0.5) * 2
	
	if v.x < bd.left then
		v.x = bd.left
	elseif v.x + v.width > bd.right then
		v.x = bd.right - v.width
	end
	
	if v.y < bd.top then
		v.y = bd.top
	elseif v.y + v.height > bd.bottom then
		v.y = bd.bottom - v.height
	end
end

camera = Camera.create()
camera.renderToScreen = true

camera2 = Camera.create()

return Camera