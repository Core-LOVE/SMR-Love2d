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
	local function pfrX(plrFrame)
		local A
		A = plrFrame
		A = A - 50
		
		while(A > 100) do
			A = A - 100
		end
		
		if(A > 90) then
			A = 9
		elseif(A > 90) then
			A = 9
		elseif(A > 80) then
			A = 8
		elseif(A > 70) then
			A = 7
		elseif(A > 60) then
			A = 6
		elseif(A > 50) then
			A = 5
		elseif(A > 40) then
			A = 4
		elseif(A > 30) then
			A = 3
		elseif(A > 20) then
			A = 2
		elseif(A > 10) then
			A = 1
		else
			A = 0
		end
		
		return A * 100
	end

	local function pfrY(plrFrame)
		local A
		A = plrFrame
		A = A - 50
		
		while(A > 100) do
			A = A - 100
		end
		
		A = A - 1
		while(A > 9) do
			A = A - 10
		end
		
		return A * 100
	end


	local function isVisible(x,y,width,height)
		for _,cam in ipairs(Camera) do
			if cam.active and x < cam.x+cam.width and x+width > cam.x and y < cam.y+cam.height and y+height > cam.y then
				return true
			end
		end

		return false
	end

	local npcManager
	local function callNPCSpecialEvent(v,eventName)
		npcManager = npcManager or require("npcManager")
		npcManager.callSpecialEvent(v,eventName)
	end

	
	function Game.drawNPC(v)
		if v.isHidden then return end

		if isVisible(v.x,v.y,v.width,v.height) then
			if v.despawnTimer >= 0 then
				if v.despawnTimer == 0 then
					callNPCSpecialEvent(v,"onInitNPC")
					callNPCSpecialEvent(v,"onAnimateNPC")
				end

				v.despawnTimer = Defines.npc_timeoffscreen
			else
				return
			end
		else
			if v.despawnTimer < 0 then
				v.despawnTimer = 0
			end

			return
		end


		v.renderingDisabled = false

		callNPCSpecialEvent("onRenderNPC")

		if v.renderingDisabled then
			return
		end

		
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

		if not isVisible(v.x,v.y,v.width,v.height) then
			return
		end

		
		local img = Graphics.sprites.background[v.id].img
		
		if img == nil then return end
		
		local config = BGO.config[v.id]
		local priority = ((config.priority) or -85) + v.zOffset

		
		Graphics.drawImageToSceneWP(img, v.x,v.y, 0,BGO.frame[v.id] * v.height, v.width,v.height, priority)
	end
	
	function Game.drawBlock(v)
		if v.isHidden or v.hiddenUntilHit then return end

		if not isVisible(v.x,v.y,v.width,v.height) then
			return
		end
		

		local img = Graphics.sprites.block[v.id].img
		
		if img == nil then return end
		
		local config = Block.config[v.id]
		local priority = (config.priority) or (config.foreground and -10) or (v.isSizeable and -90) or -65
		
		Graphics.drawImageToSceneWP(img, v.x,v.y, 0,Block.frame[v.id] * v.height, v.width,v.height, priority)
	end

	function Game.drawPlayer(v)
		local img = Graphics.sprites[v.name][v.powerup].img
		
		if img == nil then return end
		
		local fx = Player.frames[v.name]['FrameX'][(v.powerup * 100) + (v.frame * v.direction)]
		local fy = Player.frames[v.name]['FrameY'][(v.powerup * 100) + (v.frame * v.direction)]
		
		Graphics.drawImageToSceneWP(img, v.x + fx, v.y + fy, pfrX(100 + v.frame * v.direction), pfrY(100 + v.frame * v.direction), 100, 100, -25)
	end
		
	function Game.drawHud()
		-- for k,v in ipairs(Player) do
			local imgcon = Graphics.sprites.other['Container1'].img
			
			local width = love.graphics.getWidth()
			local height = love.graphics.getHeight()
			
			local offset = {x = HUDOverride.offsets.itembox.x, y = HUDOverride.offsets.itembox.y}
			local itembox = {img = imgcon, x = (width / 2) - 48, y = 0}
			
			Graphics.drawImageWP(itembox.img, itembox.x + offset.x, itembox.y + offset.y)
		-- end
	end
	
	local function sortDrawingQueue(a,b)
		return (a.priority < b.priority)
	end


	local emptyTable = {}

	function Game.updateGraphicsLevel()
		for _,v in ipairs(Effect.objs) do
			v:render(emptyTable)
		end
		
		for _,v in ipairs(Block) do
			Game.drawBlock(v)
		end

		for _,v in ipairs(BGO) do
			Game.drawBGO(v)
		end
		
		for _,v in ipairs(NPC) do
			Game.drawNPC(v)
		end
		
		for _,v in ipairs(Player) do
			local cam = Camera(1)
			if v.idx <= 2 then
				cam = Camera(v.idx)
			end
			
			Backgrounds.draw(Section(v.section), cam)
			Game.drawPlayer(v)
		end
		
		Game.drawHud()
		
		table.sort(Graphics.drawingQueue,sortDrawingQueue)

		for _,self in ipairs(Camera) do
			if self.active then
				self:draw()
			end
		end

		Graphics.drawingQueue = {}
	end
end

function Game.updateMenu()
	-- Draw logo
	
	do
		local img = Graphics.sprites.other['Logo1'].img
		
		local width = love.graphics.getWidth()
		local height = love.graphics.getHeight()
			
		Graphics.drawImageWP(img, width / 2, height / 2, -17)
	end
end

return Game