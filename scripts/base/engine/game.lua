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
		
		local img = Graphics.sprites.npc[v.id].img
		
		if img == nil then return end

		local config = NPC.config[v.id]

		local priority = (config.priority) or (config.foreground and -15) or -45

		local x = v.x+(v.width*0.5)-(config.gfxwidth*0.5)+config.gfxoffsetx
		local y = v.y+v.height-config.gfxheight+config.gfxoffsety

		
		Graphics.drawImageToSceneWP(img, x,y, 0,v.animationFrame * config.gfxheight, config.gfxwidth,config.gfxheight, priority)
	end
	
	function Game.drawBGO(v)
		if v.isHidden then return end
		
		local img = Graphics.sprites.background[v.id].img
		
		if img == nil then return end
		
		local config = BGO.config[v.id]
		local priority = ((config.priority) or -85) + v.zOffset

		
		Graphics.drawImageToSceneWP(img, v.x,v.y, 0,BGO.frame[v.id] * v.height, v.width,v.height, priority)
	end
	
	function Game.drawBlock(v)
		if v.isHidden or v.hiddenUntilHit then return end

		local img = Graphics.sprites.block[v.id].img
		
		if img == nil then return end
		
		local config = Block.config[v.id]
		local priority = (config.priority) or (config.foreground and -10) or (v.isSizeable and -90) or -65
		
		
		Graphics.drawImageToSceneWP(img, v.x,v.y, 0,Block.frame[v.id] * v.height, v.width,v.height, priority)
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