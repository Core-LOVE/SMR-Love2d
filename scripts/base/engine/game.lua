local Game = {}

function Game.SetupScreens()

end

function Game.DynamicScreen()

end

function Game.GameLoop()

end

function Game.PauseGame(plr)

end

function Game.AddCredit(newCredit)
	Credits[#Credits + 1] = newCredit
end

function Game.UpdateMacro()

end

function Game.StartBattleMode()

end

function Game.SaveGame()

end

function Game.LoadGame()

end

function Game.ClearGame(punnish)

end

function Game.UpdateGraphics2()

end

function Game.DrawInterface(Z, numScreens)

end

function Game.DrawBackground(S, Z)

end

function Game.DoCredits()

end


-- Level drawing
do
	function Game.drawBlock(camera,block)
		local img = Graphics.sprites.block[block.id].img
        
        love.graphics.draw(img,block.x-camera.x,block.y-camera.y)
	end

	function Game.updateGraphicsLevel()
		for _,self in ipairs(Camera) do
			self:draw()
		end
	end
end

return Game