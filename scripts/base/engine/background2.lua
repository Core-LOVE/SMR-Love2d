local Backgrounds = {}

BG_MAX_ID = 69
local ORIG_BG_MAX_ID = 58

local default_priority = -101

for i = 1, ORIG_BG_MAX_ID do
	Backgrounds[i] = {}
	
	if love.filesystem.getInfo("config/background2/background2-"..tostring(i).. ".txt") then
		local file = ini_parser.load("config/background2/background2-"..tostring(i)..".txt")
	
		for k in pairs(file) do
			Backgrounds[i][k] = file[k]
		end
	end
end

function Backgrounds.draw(sect, cam)
	if type(sect) ~= 'table' or sect.backgroundID == 0 then return end
	
	local bound = sect.boundary
	
	if Backgrounds[sect.backgroundID] == nil then

	end
	
	for k in pairs(Backgrounds[sect.backgroundID]) do
		local layr = Backgrounds[sect.backgroundID][k]
		
		if k ~= "background2" then
			if type(layr['img']) == 'number' then 
				local bg_img = Graphics.sprites.background2[layr['img']].img
				
				local x = (bound[string.lower(layr.alignX or 'LEFT')] - bg_img:getWidth() - cam.x) * layr.parallaxX or 1
				local y = (bound[string.lower(layr.alignY or 'BOTTOM')] - bg_img:getHeight() - cam.y) * layr.parallaxY or 1
				local w = (bound.right - bound.left) * (layr.parallaxX + 1 or 1)
				local h = (bound.bottom - bound.top)  * (layr.parallaxY + 1 or 1)
				
				local repX = 'clampzero'
				local repY = 'clampzero'
				
				if layr.repeatX then
					repX = 'repeat'
				end
				
				if layr.repeatY then
					repY = 'repeat'
				end
				
				bg_img:setWrap(repX, repY)
				Graphics.drawImageWP(bg_img, x + (layr.x or 0), y + (layr.y or 0), 0, 0, w, h, layr.priority or default_priority)
			end
		else

		end
	end
end

return Backgrounds