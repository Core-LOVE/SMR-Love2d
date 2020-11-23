isOverworld = false
LevelMacro = 0
LevelMacroCounter = 0
LevelName = ""
LevelFileName = ""
LevelScript = nil

newRECT = function()
	return {top = 0, left = 0, right = 0, bottom = 0}
end

newRECTd = function()
	return {top = 0, left = 0, right = 0, bottom = 0}
end

newLocation = function()
	return {x = 0, y = 0, width = 0, height = 0, speedX = 0, speedY = 0}
end

onTick = function() end
onTickEnd = function() end
onDraw = function() end