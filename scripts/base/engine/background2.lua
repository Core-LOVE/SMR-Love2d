local Backgrounds = {}

Backgrounds.objs = {}

BG_MAX_ID = 69
local ORIG_BG_MAX_ID = 58

for i = 1, ORIG_BG_MAX_ID do
	Backgrounds.objs[i] = {}
	local file = ini_parser.load("config/background2/background2-"..tostring(i)..".txt")

	for k,v in pairs(file) do
		Backgrounds.objs[i][k] = v
	end
	
	print(inspect(Backgrounds.objs[i]))
end

return Backgrounds