local Physics = {}

local HC = require 'game/HC/init'

function Physics.rect(x, y, w, h)
	return HC.rectangle(x, y, w, h)
end

function Physics.circle(x, y, r)
	return HC.circle(x, y, r or 16)
end

function Physics.point(x, y)
	return HC.point(x, y)
end

function Physics.polygon(t)
	return HC.polygon(unpack(t))
end

function Physics.add(p, t)
	local t = {}
	
	p.collidesBlockBottom = false
	p.collidesBlockTop = false
	p.collidesBlockLeft = false
	p.collidesBlockRight = false
	
	p.object_type = t.type or 'dynamic'
	p.object = {}
	t.shape = t.shape or 'rect'
	
	if t.shape == 'rect' then
		p.object = Physics.rect(p.x, p.y, p.width, p.height)
	elseif t.shape == 'circle' then
		p.object = Physics.circle(p.x, p.y, p.radius)
	end
	
	return true
end

local function col(v, delta)
	v.x = v.x + delta.x
	v.y = v.y + delta.y

	if delta.y < 0 then
		v.collidesBlockBottom = true
	elseif delta.y > 0 then
		v.collidesBlockTop = true
	else
		v.collidesBlockBottom = false
		v.collidesBlockTop = false
	end
	
	if delta.x < 0 then
		v.collidesBlockLeft = true
	elseif delta.x > 0 then
		v.collidesBlockRight = true
	else
		v.collidesBlockLeft = false
		v.collidesBlockRight = false
	end
	
	-- if delta.y ~= 0 then
		-- v.speedY = 0
	-- end
	
	-- if delta.x ~= 0 then
		-- v.speedX = 0
	-- end
	
	v.object:moveTo(v.x, v.y)
	
	return false
end

function Physics.onCollision(v, b)	
	local c = true
	
    for shape, delta in pairs(HC.collisions(v.object)) do
		c = col(v, delta)
    end
	
	if not c then return end
	
	v.collidesBlockBottom = false
	v.collidesBlockTop = false
	v.collidesBlockLeft = false
	v.collidesBlockRight = false
end

function Physics.applyCollisions(v)
	local o = v.object
	
	v.x = v.x + v.speedX
	v.y = v.y + v.speedY
	
	o:moveTo(v.x, v.y)
	
	Physics.onCollision(v,b)
end

function Physics.update(dt)

end

return Physics