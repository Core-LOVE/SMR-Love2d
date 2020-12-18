local gui = {windows = {}}

--load classes
local path = ...
path = path .. [[/]]
local gfxpath = path .. "gfx/"

Window = require(path.."class/window")

--functions
function gui.createWindow(args)
	local w = Window.new()
	
	for k in pairs(args) do
		w[k] = args[k]
		print(k.."="..args[k])
	end
	
	if w.canClose then
		w.closebutton = love.graphics.newImage(gfxpath.."closebutton.png")
		w.q = love.graphics.newQuad(0, 0, w.closebutton:getWidth(), w.closebutton:getHeight() / 3, w.closebutton:getDimensions())
	end
	
	if w.icon ~= nil then
		w.icon_img = love.graphics.newImage(w.icon)
	end
	
	if w.name ~= nil then
		w.name = tostring(w.name)
	end
	
	w.width = w.width + 18
	w.height = w.height + 42
	
	w.realX = w.x or 0
	w.realY = w.y or 0
	w.x = w.realX + 8
	w.y = w.realY + 32
	
	w.canvas = love.graphics.newCanvas(w.width, w.height)
	
	table.insert(gui.windows, w)
	return gui.windows[#gui.windows]
end

function gui:draw()
	for k,v in ipairs(gui.windows) do
		Window:draw(v)
	end
end

function gui:tick()
	for k,v in ipairs(gui.windows) do
		if v.remove == nil then
			v.remove = function(self)
				table.remove(gui.windows, k)
				return self
			end
		end
		Window:update(v)
	end
end

return gui