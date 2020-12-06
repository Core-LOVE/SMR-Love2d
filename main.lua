local ms = "scripts/base/"

ini_parser = require(ms.."ini_parser")
txt_parser = require(ms.."txt_parser")
inspect = require(ms.."inspect")

Audio = require(ms.."engine/audio")
Graphics = require(ms.."engine/graphics")
Credit = require(ms.."engine/credits")
Game = require(ms.."engine/game")
Globals = require(ms.."engine/globals")
Defines = require(ms.."engine/defines")
BasicColliders = require(ms.."engine/collision")
SFX = require(ms.."sfx")

Window = love.window

do
	love.graphics.clear()
	local quad = love.graphics.newQuad(0, 0, 32, 32, 32, 128)
	love.graphics.draw(love.graphics.newImage('graphics/ui/LoadCoin.png'), quad, 800 - 48, 600 - 48)
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
	Section.createSections(21)
	-- temp
	local levelParser = require(ms.."engine/levelparser")

	levelParser.load("_test levels/a couple blocks.lvlx")
end

function love.draw()
	onDrawEnd()
	Game.updateGraphicsLevel()
	onDraw()
end

function love.update(dt)
	Window = love.window
	
	onTickEnd()

	Player.updateKeys()
	
	Block.update()
	NPC.update()
	Player.update()
	
	Block.frames()
	BGO.frames()
	NPC.frames()

	if dt < 1/FRAMES_PER_SECOND then
		love.timer.sleep(1/FRAMES_PER_SECOND - dt)
	end
	
	onTick()
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