local Backgrounds = {}

Backgrounds.objs = {}

BG_MAX_ID = 69
local ORIG_BG_MAX_ID = 58

for i = 1, ORIG_BG_MAX_ID do
	Backgrounds.objs[i] = {}
	local file = ini_parser.load("config/background2/background2-"..tostring(i)..".txt")

	Backgrounds.objs[i] = {layers = {}, main = {}}
	
	Backgrounds.objs[i].layers.parallaxX = 0
	Backgrounds.objs[i].layers.parallaxY = 0
	Backgrounds.objs[i].layers.priority = -101
	
	for k,v in pairs(file) do
		if k ~= "background2" then
			Backgrounds.objs[i].layers[k] = v
		else
			Backgrounds.objs[i].main[k] = v
		end
	end
end

function Backgrounds.draw(s,c)
	if #Section == 0 or Section(s).backgroundID == 0 then return end
	
	local sec = Section(s)
	local v = Backgrounds.objs[1].layers
	
	for _,l in ipairs(v) do
		local img = nil
		local qd = nil
		
		if type(v.img) == 'number' then
			img = Graphics.sprites.background2[v.img].img
		elseif type(v.img) ~= 'number' and v.img ~= nil then
			img:setWrap("repeat", "repeat")
		end
		
		local cx = (sec.boundary.left - (c.x + sec.boundary.left)) * v.parallaxX
		local cy = (sec.boundary.top - (c.y + sec.boundary.top)) * v.parallaxY
		
		if not qd then
			-- qd = love.graphics.newQuad(cx, cy, , map_height_in_pixels, bg_image:getWidth(), bg_image:getHeight())
		end
		
		if img ~= nil then
			Graphics.drawImageWP(img, cx, cy, l.priority)
		end
	end
end

return Backgrounds