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


Text = {}
Text.print = function(...)
	local string = arg[1]
	local type = 2
	local x = arg[2]
	local y = arg[3]
	
	if #args == 4 then
		type = arg[2]
		x = arg[3]
		y = arg[4]
	end
end

globalKeys = {}

globalKeys[1] = {
left = 'left',
right = 'right',
up = 'up',
down = 'down',
run = 'x',
jump = 'z',
altJump = 'a'
}

onStart = function() end
onTick = function() end
onTickEnd = function() end
onDraw = function() end
onDrawEnd = function() end