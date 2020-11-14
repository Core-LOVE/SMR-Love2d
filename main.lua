ini_parser = require("scripts/base/ini_parser")
Audio = require("scripts/base/engine/audio")
Graphics = require("scripts/base/engine/graphics")
Credit = require("scripts/base/engine/credits")
Game = require("scripts/base/engine/game")

do
	love.graphics.clear()
	love.graphics.present()
end

function love.load()
	print(":)")
	Audio.loadSounds()
	Graphics.loadGraphics()
end

function love.draw()

end