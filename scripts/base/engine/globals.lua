isOverworld = false

LevelMacro = 0
LevelMacroCounter = 0
LevelName = ""
LevelFileName = ""
LevelPath = ""
LevelScript = nil

WorldPath = ""
WorldPath2 = ""

isPaused = false

isOutro = false
TitleMenu = false

function tobool(v)
    return v and ( (type(v)=="number") and (v==1) or ( (type(v)=="string") and (v=="true") ) )
end

function tohex(num)
	local hexstr = '0123456789abcdef'
	local s = ''
	while num > 0 do
	   local mod = math.fmod(num, 16)
	   s = string.sub(hexstr, mod+1, mod+1) .. s
	   num = math.floor(num / 16)
	end
	if s == '' then s = '0' end
	return s
end

newRECT = function()
	return {top = 0, left = 0, right = 0, bottom = 0}
end

newRECTd = function()
	return {top = 0, left = 0, right = 0, bottom = 0}
end

newLocation = function()
	return {x = 0, y = 0, width = 0, height = 0, speedX = 0, speedY = 0}
end
 
SuperPrint = function(strg, typ, x, y)
	strg = tostring(strg) or ""
	typ = typ or 3
	x = x or 0
	y = y or 0
	
	local B = 0
	local C = 0
	
	if typ == 3 then
		local fimg = Graphics.sprites.other['Font2_2'].img
		local strg = strg:upper()
		
		for cs = 1, #strg do
			local c = string.sub(strg, cs, cs)
			c = c:byte()
			
            if(c >= 33 and c <= 126) then
                C = (c - 33) * 32
				Graphics.drawImage(fimg, x + B, y, 2, C, 18, 16)
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