local Misc = {}

function Misc.isPaused()
	return isPaused
end

function Misc.pause(bool)
	isPaused = bool or true
	
	local ev = "onPause"
	if not isPaused then
		ev = "onUnpause"
	end
	
	EventManager.callEvent(ev)
end

function Misc.inEditor()
	--:)
end

function Misc.score()

end

function Misc.givePoints(addScore, x, y, multiplier)
	-- if TitleMenu or isOverworld or isOutro then return end
	
	-- local A = addScore + (multiplier or 0)
	-- if A == 0 then return end
	
	-- if A > 13 then A = 13 end
	
	-- if A < addScore then A = addScore end
	
	-- if type(multiplier) == 'number' and multiplier > 9 then multiplier = 8 end
	
end

return Misc