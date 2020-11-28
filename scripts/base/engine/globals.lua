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
	local type = 3
	local x = arg[2]
	local y = arg[3]
	
	if #arg == 4 then
		type = arg[2]
		x = arg[3]
		y = arg[4]
	end
	
	local B = 0
	local C = 0
	
	if type == 2 then
        for c = 1, #string do
            if(c >= 48 and c <= 57) then
                C = (c - 48) * 16
                Graphics.drawImage(Graphics.sprites.hardcoded['45-1'], x + B, y, C, 0, 15, 17)
                B = B + 16
            elseif(c >= 65 and c <= 90) then
                C = (c - 55) * 16
                Graphics.drawImage(Graphics.sprites.hardcoded['45-1'], x + B, y, C, 0, 15, 17)
                B = B + 16
            elseif(c >= 97 and c <= 122) then
                C = (c - 61) * 16
                Graphics.drawImage(Graphics.sprites.hardcoded['45-1'], x + B, y, C, 0, 15, 17)
                B = B + 16
            elseif(c >= 33 and c <= 47) then
                C = (c - 33) * 16
                Graphics.drawImage(Graphics.sprites.hardcoded['45-1'], x + B, y, C, 0, 15, 17)
                B = B + 16
            elseif(c >= 58 and c <= 64) then
                C = (c - 58 + 15) * 16
                Graphics.drawImage(Graphics.sprites.hardcoded['40-1'], x + B, y, C, 0, 15, 17)
                B = B + 16
            elseif(c >= 91 and c <= 96) then
                C = (c - 91 + 22) * 16
                Graphics.drawImage(Graphics.sprites.hardcoded['40-1'], x + B, y, C, 0, 15, 17)
                B = B + 16
            elseif(c >= 123 and c <= 125) then
                C = (c - 123 + 28) * 16
                Graphics.drawImage(Graphics.sprites.hardcoded['40-1'], x + B, y, C, 0, 15, 17)
                B = B + 16
            else
                B = B + 16
            end
        end	
	elseif type == 3 then
		local str = string:upper()
		
		for c = 1, #str do
            if(c >= 33 and c <= 126) then
                C = (c - 33) * 32
				Graphics.drawImage(Graphics.sprites.hardcoded['45-2'], x + B, y, 2, C, 18, 16)
                B = B + 18
                if(c == 'M') then
                    B = B + 2
				end
            else
                B = B + 16
            end
		end
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