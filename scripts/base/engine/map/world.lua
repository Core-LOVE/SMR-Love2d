local world = {}

world.playerX = 0
world.playerY = 0
world.playerSpeedX = 0
world.playerSpeedY = 0
world.playerWalkingDirection = 0
world.playerWalkingTimer = 0
world.playerWalkingFrame = 0
world.playerWalkingFrameTimer = 0
world.playerIsCurrentWalking = false
world.worldTitle = ""
world.levelTitle = ""
world.levelObj = nil
world.playerCurrentDirection = 3


world.update = {}

world.update.camera = function()
	camera.x = (world.playerX + 16) - camera.width / 2
	camera.y = (world.playerY + 16) - camera.height / 2
end

world.update.player = function()
	if love.keyboard.isDown('x') then
		local x,y = world.playerX, world.playerY
		
		for k,v in ipairs(Level.getIntersecting(x,y,x + 32, y + 32)) do
			if v.filename ~= "" then
				Level.load(v.filename)
			end
		end
	end
end

setmetatable(world.update, {__call = function(self)
	return self.camera(), self.player()
end})

return world