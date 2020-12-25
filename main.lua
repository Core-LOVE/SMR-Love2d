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

HUDOverride    = require("hudoverride")
Audio          = require("engine/audio")
Graphics       = require("engine/graphics")
Credit         = require("engine/credits")
Game           = require("engine/game")
Defines        = require("engine/defines")
Globals        = require("engine/globals")
BasicColliders = require("engine/collision")
SFX            = require("sfx")
Window         = require("engine/window")

local levelParser = require("engine/levelparser")


do
	love.graphics.clear()
	local quad = love.graphics.newQuad(0, 0, 32, 32, 32, 128)
	love.graphics.draw(Graphics.loadImage('graphics/ui/LoadCoin.png'), quad, 800 - 48, 600 - 48)
	love.graphics.present()
end

FRAMES_PER_SECOND = 64.102

local function load_objects()
	Camera      = require("engine/camera")
	Layer       = require("engine/layer")
	Liquid      = require("engine/liquid")
	Block       = require("engine/block")
	NPC         = require("engine/npc")
	BGO         = require("engine/bgo")
	Player      = require("engine/player")
	Section     = require("engine/section")
	Backgrounds = require("engine/background2")
	Warp		= require("engine/warp")
	Effect      = require("game/effect")

	Animation = Effect

	NPC.load()
	Effect.load()
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
end

function love.draw()
	EventManager.callEvent("onDraw")

	Game.updateGraphicsLevel()
	
	EventManager.callEvent("onDrawEnd")


	collectgarbage()
end

function love.update(dt)
	EventManager.callEvent("onTick")


	Player.updateKeys()
	
	Block.update()
	Player.update()
	NPC.update()
	Effect.update()
	
	Camera.update()
	
	Block.frames()
	BGO.frames()
	NPC.frames()
	
	if dt < 1 / FRAMES_PER_SECOND then
		love.timer.sleep(1 / FRAMES_PER_SECOND - dt)
	end
	

	EventManager.callEvent("onTickEnd")


	collectgarbage()
end

function love.filedropped(file)
	file:open("r")
	local data = file:read()
	
	levelParser.load(data)
end


local screenshotter = require("engine/screenshotter")

function love.keypressed(key,scancode,isrepeat)
	if key == "f12" and not isrepeat then
		screenshotter.takeScreenshot()
	end
end