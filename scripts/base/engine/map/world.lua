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

world.update = function()
	-- Camera
	
	camera.x = (world.playerX + 16) - camera.width / 2
	camera.y = (world.playerY + 16) - camera.height / 2
	
	
end

return world