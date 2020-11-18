ini_parser = require("scripts/base/ini_parser")
Audio = require("scripts/base/engine/audio")
Graphics = require("scripts/base/engine/graphics")
Credit = require("scripts/base/engine/credits")
Game = require("scripts/base/engine/game")
Globals = require("scripts/base/engine/globals")

do
	love.graphics.clear()
	love.graphics.present()
end

function love.load()
	print(":)")
	--Audio.loadSounds()
	--Graphics.loadGraphics()

	-- temp
	local levelParser = require("scripts/base/engine/levelparser")

	levelParser.load("_test levels/a couple blocks.lvlx")
end

function love.draw()

end