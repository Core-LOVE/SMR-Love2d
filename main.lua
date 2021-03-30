require("scripts/base/error_handler")
require("scripts/base/sdl2lib")
require("lovefs")

fs = lovefs(love.filesystem.getWorkingDirectory())
path = string.gsub(fs.current, [[\]], [[/]])

do
	local function compile(bool)
		if bool == false then return end
		
		love.filesystem.setRequirePath(path.."/")
	end

	compile(false)
end


EventManager = require("scripts/base/engine/eventmanager")
-- EventManager overwrites require, so we can use a shorter path after


require("const")
require("io") 
require("math")

ini_parser     = require("ini_parser")
txt_parser     = require("txt_parser")
inspect        = require("inspect")

Physics		   = require("game/physics")
HUDOverride    = require("hudoverride")
Audio          = require("engine/audio")
Graphics       = require("engine/graphics")
Credit         = require("engine/credits")
Game           = require("engine/game")
Defines        = require("engine/defines")
Globals        = require("engine/globals")
BasicColliders = require("engine/collision")
SFX            = require("sfx")
Misc 		   = require("engine/misc")
Window         = require("engine/window")
Level 		   = require("engine/level")

local levelParser = require("engine/levelparser")
local worldParser = require("engine/map/worldparser")

do
	love.graphics.clear()
	local quad = love.graphics.newQuad(0, 0, 32, 32, 32, 128)
	love.graphics.draw(Graphics.loadImage('graphics/ui/LoadCoin.png'), quad, 800 - 48, 600 - 48)
	love.graphics.present()
end

FRAMES_PER_SECOND = 64.102

local function load_objects()
	-- Level
	
	Player      = require("engine/player")
	Camera      = require("engine/camera")
	Layer       = require("engine/layer")
	Liquid      = require("engine/liquid")
	Block       = require("engine/block")
	NPC         = require("engine/npc")
	BGO         = require("engine/bgo")
	Section     = require("engine/section")
	Backgrounds = require("engine/background2")
	Warp		= require("engine/warp")
	Effect      = require("game/effect")

	Animation = Effect

	NPC.load()
	Effect.load()
	
	-- World map
	
	world = require("engine/map/world")
	Tile = require("engine/map/tile")
	Path = require("engine/map/path")
	Scenery = require("engine/map/scenery")
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	return function()
		local frametimestart = love.timer.getTime()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end
 
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
 
			if love.draw then love.draw() end
 
			love.graphics.present()
		end
 
		local frametimeend = love.timer.getTime()
		local framedelta = frametimeend - frametimestart
		
		local sleeptime = (1 / FRAMES_PER_SECOND) - framedelta
		if love.timer then love.timer.sleep(sleeptime) end
	end
end

function love.load()
	print("Program name", arg[0])
	print("Arguments:")
	for l = 1, #arg do
		print(l," ",arg[l])
	end
	
	--Audio.loadSounds()
	Graphics.loadUi()
	love.graphics.setDefaultFilter("nearest", "nearest")
	Audio.loadSounds()
	--Graphics.loadGraphics(false)
	load_objects()

	-- temp
	levelParser.load("_test levels/a couple blocks.lvlx")
	-- worldParser.load("_test levels/a couple tiles.wldx")
end

local some_img = Graphics.loadImage("graphics/effect-5.png")

function love.draw()
	EventManager.callEvent("onDraw")

	if not isOverworld then
		Game.updateGraphicsLevel()
	else
		Game.updateGraphicsWorld()
	end
	
	if TitleMenu then
		Game.updateMenu()
	end
	
	EventManager.callEvent("onDrawEnd")


	Graphics.glDraw{
		texture = some_img,
	}
	
	collectgarbage()
end

function love.update(dt)
	if isPaused then return end
	
	Physics.update(dt)
	EventManager.callEvent("onTick")

	Player.updateKeys()
	
	if not isOverworld then
		Block.frames()
		BGO.frames()
		Block.update()
		Player.update()
		NPC.update()
		Camera.update()	
		NPC.frames()
	else
		world.update()
	end
	
	Effect.update()
	
	if dt < 1 / FRAMES_PER_SECOND then
		love.timer.sleep(1 / FRAMES_PER_SECOND - dt)
	end

	EventManager.callEvent("onTickEnd")
	
	collectgarbage()
end

function love.filedropped(file)
	file:open("r")
	local data = file:read()
	print(file:seek())
	levelParser.load(nil, data)
end


local screenshotter = require("engine/screenshotter")

function love.keypressed(key,scancode,isrepeat)
	if key == "f12" and not isrepeat then
		screenshotter.takeScreenshot()
	end
end