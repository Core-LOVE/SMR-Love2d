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

    v.x = -200000
    v.y = -200600

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

    if self.renderToScreen then
        love.graphics.draw(self.canvas,self.renderX,self.renderY)
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

camera = Camera.create()
camera.renderToScreen = true

camera2 = Camera.create()

return Camera