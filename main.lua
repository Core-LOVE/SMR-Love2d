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

Window = love.window


FRAMES_PER_SECOND = 64.102

do
	love.graphics.clear()
	love.graphics.present()
end

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
end

function love.load()
	--Audio.loadSounds()
	love.graphics.setDefaultFilter("nearest", "nearest")
	Audio.loadSounds()
	Graphics.loadUi()
	Graphics.loadGraphics(false)
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
	
	Block.update()
	NPC.update()
	
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