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
	function Game.drawBlock(v)
		local img = Graphics.sprites.block[v.id].img
        
		Graphics.drawImageToSceneWP(img,v.x,v.y,0,0,v.width,v.height,-65)
	end


	local function sortDrawingQueue(a,b)
		return (a.priority < b.priority)
	end

	function Game.updateGraphicsLevel()
		for _,v in ipairs(Block) do
			Game.drawBlock(v)
		end


		table.sort(Graphics.drawingQueue,sortDrawingQueue)

		for _,self in ipairs(Camera) do
			if self.active then
				self:draw()
			end
		end

		Graphics.drawingQueue = {}
	end
end

return Game