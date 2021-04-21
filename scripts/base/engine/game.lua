local Game = {cursor = 0, cursorDelay = 0}

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
	
do
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
		if v.name == "null" or v.deathState then return end
		
		local img = Graphics.sprites[v.name][v.powerup].img
		
		if img == nil then return end
		
		local fx = Player.frames[v.name]['FrameX'][(v.powerup * 100) + (v.frame * v.direction)]
		local fy = Player.frames[v.name]['FrameY'][(v.powerup * 100) + (v.frame * v.direction)]
		
		Graphics.drawImageToSceneWP(img, v.x + fx, v.y + fy, pfrX(100 + v.frame * v.direction), pfrY(100 + v.frame * v.direction), 100, 100, priority or -25)
	end
	
	function Game.drawTile(v)
		if v.isHidden then return end
		
		if not isVisible(v.x,v.y,v.width,v.height) then
			return
		end

		
		local img = Graphics.sprites.tile[v.id].img
		
		if img == nil then return end
		
		local frame = 0
		local priority = -65
		
		Graphics.drawImageToSceneWP(img, v.x, v.y, 0, frame, v.width, v.height, priority)
	end
	
	function Game.drawPath(v)
		if v.isHidden then return end
		
		if not isVisible(v.x,v.y,v.width,v.height) then
			return
		end

		
		local img = Graphics.sprites.path[v.id].img
		
		if img == nil then return end
		
		local frame = 0
		local priority = -60
		
		Graphics.drawImageToSceneWP(img, v.x, v.y, 0, frame, v.width, v.height, priority)
	end
	
	function Game.drawScene(v)
		if v.isHidden then return end
		
		if not isVisible(v.x,v.y,v.width,v.height) then
			return
		end

		
		local img = Graphics.sprites.scene[v.id].img
		
		if img == nil then return end
		
		local frame = 0
		local priority = -60
		
		Graphics.drawImageToSceneWP(img, v.x, v.y, 0, frame, v.width, v.height, priority)
	end
	
	function Game.drawLevel(v)
		if v.isHidden then return end
		
		if not isVisible(v.x,v.y,v.width,v.height) then
			return
		end

		
		local img = Graphics.sprites.level[v.id].img
		
		if img == nil then return end
		
		local frame = 0
		local priority = -60
		
		Graphics.drawImageToSceneWP(img, v.x, v.y, 0, frame, v.width, v.height, priority)
	end
	
	
	function Game.drawHud()
		for k,v in ipairs(Camera) do
			if v.renderToScreen then
				local imgcon = Graphics.sprites.other['Container0'].img
				
				local width = v.width
				local height = v.height
				
				local offset = {x = HUDOverride.offsets.itembox.x, y = HUDOverride.offsets.itembox.y}
				local itembox = {img = imgcon, x = (width / 2) - (24 + 6), y = 0}
				
				Graphics.drawImageWP(itembox.img, itembox.x + offset.x, itembox.y + offset.y, 5)
			end
		end
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
		
		if not TitleMenu then
			Game.drawHud()
		end
		
		table.sort(Graphics.drawingQueue,sortDrawingQueue)

		for _,self in ipairs(Camera) do
			if self.active then
				self:draw()
			end
		end

		Graphics.drawingQueue = {}
	end
	
	function Game.updateGraphicsWorld()
		for _,v in ipairs(Tile) do
			Game.drawTile(v)
		end
		
		for _,v in ipairs(Path) do
			Game.drawPath(v)
		end
		
		for _,v in ipairs(Level) do
			Game.drawLevel(v)
		end
		
		for _,v in ipairs(Scenery) do
			Game.drawScene(v)
		end
		
		for _,v in ipairs(Effect.objs) do
			v:render(emptyTable)
		end
		
		-- Draw world map's player
		
		do
			local img = Graphics.sprites.player[1].img
			
			world.playerWalkingFrameTimer = (world.playerWalkingFrameTimer + 1) % 9
			if world.playerWalkingFrameTimer >= 8 then
				world.playerWalkingFrame = (world.playerWalkingFrame + 1) % 2
			end
			
			Graphics.drawImageToSceneWP(img, world.playerX, world.playerY, 
			0, 32 * world.playerWalkingFrame, 32, 32, -50)
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

function Game.updateMenu()
	-- Draw logo
	
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	
	local logo = Graphics.sprites.other['Logo1'].img
		
	local width = w - logo:getWidth()
	local height = h - logo:getHeight() * 3	
	
	local menu = {
		[1] = "1 Player Game",
		[2] = "2 Player Game",
		[3] = "Battle Game",
		[4] = "Options",
		[5] = "Exit",
	}
	
	do
		Graphics.drawImageWP(logo, width / 2, height / 2)
		
		-- for i = 1, #menu do
			-- SuperPrint(menu[i], 3, w / 2.75, (height * 2.5) + (32 * (i - 1)))
		-- end
	end
	
	-- Menu 1
	
	-- do
		-- local p = Player(1)
		
		-- if p then
			-- local cursor1 = Graphics.sprites.other['MCursor0'].img
		
			-- if Game.cursorDelay > 0 then
				-- Game.cursorDelay = Game.cursorDelay - 1
			-- elseif Game.cursorDelay <= 0 then
				-- if p.keys.down then
					-- SFX.play(26)
					-- Game.cursor = (Game.cursor + 1) % #menu
					-- Game.cursorDelay = 6
				-- elseif p.keys.up then
					-- SFX.play(26)
					-- Game.cursor = Game.cursor - 1
					-- if Game.cursor < 0 then
						-- Game.cursor = #menu - 1
					-- end
					-- Game.cursorDelay = 6
				-- end
			-- end
			
			-- Graphics.drawImageWP(cursor1, w / 2.75 - (cursor1:getWidth() * 1.5), (height * 2.5) + (32 * Game.cursor))
		-- end
	-- end
	
	-- Menu 2
	do
		for i = 1, #Player.script do
			local s = Player.script[i]
			
			local img = Graphics.sprites.other['Container4'].img
			
			local iw = img:getWidth() * 1.5
			
			Graphics.drawImageWP(img, 128 + (iw * i), 300)
			
			if type(s) == 'table' then				
				local v = {
					powerup = 1,
					direction = 1,
					
					x = 128 + (iw * i) + 16,
					y = 312,
					
					frame = 15
				}
				
				local simg = Graphics.sprites[s.name][v.powerup].img
				
				local fx = Player.frames[s.name]['FrameX'][(v.powerup * 100) + (v.frame * v.direction)]
				local fy = Player.frames[s.name]['FrameY'][(v.powerup * 100) + (v.frame * v.direction)]
				
				Graphics.drawImageWP(simg, v.x + fx, v.y + fy, pfrX(100 + v.frame * v.direction), pfrY(100 + v.frame * v.direction), 100, 100, 5)
				SuperPrint(s.name, 3, (128 + (iw * i)) - (s.name:len() * 3), v.y + 48)
			end
		end
	end
end

return Game