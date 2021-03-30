local Physics = {}
love.physics.setMeter(32) -- the height of a meter our worlds will be 32px
Physics.world = love.physics.newWorld(0, 0, true)

--[[this function represents rectangular body]]
function Physics.add(obj, bodyType, shape, t)
	obj = obj or {x = 0, y = 0, width = 32, height = 32}
	bodyType = bodyType or 'dynamic'
	shape = shape or 'Rectangle' 
	
	obj.collidesBlockBottom = false
	obj.collidesBlockTop = false
	obj.collidesBlockRight = false
	obj.collidesBlockLeft = false

	obj.body = love.physics.newBody(Physics.world, obj.x, obj.y, bodyType)
	
	if shape == 'Rectangle' then
		obj.shape = love.physics.newRectangleShape(obj.width, obj.height)
	elseif shape == 'Circle' then
		obj.shape = love.physics.newCircleShape(obj.x, obj.y, obj.radius)
	elseif shape == 'Polygon' then
		obj.shape = love.physics.newPolygonShape(unpack(t))
	end
	
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)
	obj.fixture:setUserData(obj)

	Physics[#Physics + 1] = obj
end

function Physics.update(dt)
	Physics.world:update(dt)
	
	for i = 1, #Physics do
		local v = Physics[i]
		
		if v then
			local b = v.body
			
			v.x = b:getX()
			v.y = b:getY()
			b:setLinearVelocity(v.speedX * 96, v.speedY * 96)
		end
	end
end

--[[
a is the first fixture object in the collision.
b is the second fixture object in the collision.
c is the contact object created.
n is the amount of impulse applied along the normal of the first point of collision. It only applies to the postsolve callback, and we can ignore it for now.
t is the amount of impulse applied along the tangent of the first point of collision. It only applies to the postsolve callback, and we can ignore it for now.
]]

--beginContact gets called when two fixtures start overlapping (two objects collide).
function Physics.beginContact(a, b, c)
	local x,y = c:getNormal()
	local v = a:getUserData()
	
	if y > 0 then
		v.collidesBlockBottom = true
	elseif y < 0 then
		v.collidesBlockTop = true
	end	
	
	if x < 0 then
		v.collidesBlockLeft = true
	elseif x > 0 then
		v.collidesBlockRight = true
	end
end

--endContact gets called when two fixtures stop overlapping (two objects disconnect).
function Physics.endContact(a, b, c)
	local x,y = c:getNormal()
	local v = a:getUserData()
	
end

--preSolve is called just before a frame is resolved for a current collision
function Physics.preSolve(a, b, c)

end

--postSolve is called just after a frame is resolved for a current collision.
function Physics.postSolve(a, b, c, n, t)

end

Physics.world:setCallbacks(Physics.beginContact, Physics.endContact, Physics.preSolve, Physics.postSolve)
return Physics