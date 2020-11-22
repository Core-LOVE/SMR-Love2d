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
	function Game.drawNPC(v)
		if v.isHidden then return end
		
		local priority = -45
		local img = Graphics.sprites.npc[v.id].img
		
		if img == nil then return end
		
		if NPC.config[v.id].foreground then priority = -15 elseif NPC.config[v.id].isvine or NPC.config[v.id].isplant then priority = -75 end
		
		Graphics.drawImageToSceneWP(img, v.x + NPC.config[v.id].gfxoffsetx, v.y + NPC.config[v.id].gfxoffsety, 0, v.animationFrame * v.height,v.width,v.height, priority)
	end
	
	function Game.drawBGO(v)
		if v.isHidden then return end
		
		local priority = -85
		local img = Graphics.sprites.background[v.id].img
		
		if img == nil then return end
		
		if BGO.config[v.id].foreground then priority = -20 end
		
		Graphics.drawImageToSceneWP(img,v.x,v.y,0, BGO.frame[v.id] * v.height,v.width,v.height, priority)
	end
	
	function Game.drawBlock(v)
		if v.isHidden or v.hiddenUntilHit then return end

		local priority = -65
		local img = Graphics.sprites.block[v.id].img
		
		if img == nil then return end
		
		if v.isSizeable then priority = -90 elseif Block.config[v.id].foreground then priority = -10 end
		
		Graphics.drawImageToSceneWP(img,v.x,v.y,0, Block.frame[v.id] * v.height,v.width,v.height, priority)
	end


	local function sortDrawingQueue(a,b)
		return (a.priority < b.priority)
	end

	function Game.updateGraphicsLevel()
		for _,v in ipairs(Block) do
			Game.drawBlock(v)
		end

		for _,v in ipairs(BGO) do
			Game.drawBGO(v)
		end
		
		for _,v in ipairs(NPC) do
			Game.drawNPC(v)
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