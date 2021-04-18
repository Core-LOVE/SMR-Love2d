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

function Physics.add(t)
	local t = t or {}
	local o = {}
	
	t.shape = t.shape or 'rect'
	t.parent = t.parent or {x = 0, y = 0, width = 32, height = 32, radius = 16}
	
	t.parent.collidesBlockBottom = false
	t.parent.collidesBlockLeft = false
	t.parent.collidesBlockRight = false
	t.parent.collidesBlockTop = false
	
	t.type = t.type or 'dynamic'
	
	if t.shape == 'rect' or t.shape == 'circle' or t.shape == 'point' then
		t.x = t.x or t.parent.x
		t.y = t.y or t.parent.y
		
		if t.shape == 'rect' then
			t.width = t.width or t.parent.width
			t.height = t.height or t.parent.height
			
			o = Physics.rect(t.x, t.y, t.width, t.height)
		elseif t.shape == 'circle' then
			t.radius = t.radius or t.parent.radius
			
			o = Physics.circle(t.x, t.y, t.radius)
		else
			o = Physics.point(t.x, t.y)
		end
		
	else
		t.vertices = t.vertices or {t.parent.x, t.parent.y, t.parent.x + t.parent.width, t.parent.y + t.parent.height}
		
		o = Physics.polygon(t.vertices)
	end
	
	o.object_type = t.type
	o.object_parent = t.parent
	table.insert(Physics, o)
	return o
end

function Physics.onCollision(p, shape, delta)
	p.x = p.x + delta.x
	p.y = p.y + delta.y
	
	if delta.y < 0 then
		p.speedY = 0
		p.collidesBlockBottom = true
	elseif delta.y > 0 then
		p.y = p.y + 1
		p.speedY = 0.1
		p.collidesBlockTop = true
	end
	
	-- if delta.x > 0 then
		-- p.speedX = 0
		-- p.collidesBlockRight = true
	-- end
end

function Physics.update(dt)
	for i = 1, #Physics do
		local v = Physics[i]
		
		if v then
			local p = v.object_parent
			if p.x and p.y then
				v:moveTo(p.x, p.y) 
			end
			
			if v.object_type == 'dynamic' then	
				for shape, delta in pairs(HC.collisions(v)) do
					Physics.onCollision(p, shape, delta)
				end
				
				p.x = p.x + p.speedX
				p.y = p.y + p.speedY			
			end
		end
	end
end

return Physics