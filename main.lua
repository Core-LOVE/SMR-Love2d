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

local ms = "scripts/base/"

require(ms.."const")
require(ms.."io")
require(ms.."math")

ini_parser = require(ms.."ini_parser")
txt_parser = require(ms.."txt_parser")
inspect = require(ms.."inspect")

HUDOverride = require(ms.."hudoverride")
Audio = require(ms.."engine/audio")
Graphics = require(ms.."engine/graphics")
Credit = require(ms.."engine/credits")
Game = require(ms.."engine/game")
Defines = require(ms.."engine/defines")
Globals = require(ms.."engine/globals")
BasicColliders = require(ms.."engine/collision")
SFX = require(ms.."sfx")
Window = require(ms.."engine/window")

do
	love.graphics.clear()
	local quad = love.graphics.newQuad(0, 0, 32, 32, 32, 128)
	love.graphics.draw(Graphics.loadImage('graphics/ui/LoadCoin.png'), quad, 800 - 48, 600 - 48)
	love.graphics.present()
end

FRAMES_PER_SECOND = 64.102

local function load_objects()
	Camera = require(ms.. "engine/camera")
	Layer = require(ms.."engine/layer")
	Liquid = require(ms.."engine/liquid")
	Block = require(ms.."engine/block")
	NPC = require(ms.."engine/npc")
	BGO = require(ms.."engine/bgo")
	Player = require(ms.."engine/player")
	Effect = require(ms.."engine/effect")
	Section = require(ms.."engine/section")
	Backgrounds = require(ms.."engine/background2")
end

function love.load()
	--Audio.loadSounds()
	love.graphics.setDefaultFilter("nearest", "nearest")
	Audio.loadSounds()
	Graphics.loadUi()
	--Graphics.loadGraphics(false)
	load_objects()
	-- temp
	local levelParser = require(ms.."engine/levelparser")

	levelParser.load("_test levels/a couple blocks.lvlx")
end

function love.draw()
	onDrawEnd()
	Game.updateGraphicsLevel()
	onDraw()
	-- GUI:draw()
end

function love.update(dt)
	-- Window = love.window
	
	onTickEnd()

	Player.updateKeys()
	
	Block.update()
	Player.update()
	NPC.update()
	
	Camera.update()
	
	Block.frames()
	BGO.frames()
	NPC.frames()
	Effect.frames()
	
	if dt < 1 / FRAMES_PER_SECOND then
		love.timer.sleep(1 / FRAMES_PER_SECOND - dt)
	end
	
	onTick()
	
	-- GUI:tick()
	collectgarbage()
end

function love.filedropped(file)
	file:open("r")
	local data = file:read()
	
	local levelParser = require(ms.."engine/levelparser")
	levelParser.load(data)
end


local screenshotter = require(ms.. "engine/screenshotter")

function love.keypressed(key,scancode,isrepeat)
	if key == "f12" and not isrepeat then
		screenshotter.takeScreenshot()
	end
end