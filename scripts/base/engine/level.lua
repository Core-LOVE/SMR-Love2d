local level = {}

function level.exit()
	
end

function level.winState(value)
	if value == nil then
		return LevelMacro
	else
		LevelMacro = value or 0
	end
end

function level.winTimer(value)
	if value == nil then
		return LevelMacroCounter
	else
		LevelMacroCounter = value or 0
	end
end

function level.load(levelFilename, episodeFolderName, warpIndex)

end

function Level.loadPlayerHitBoxes(characterId, powerUpId, iniFilename)

end

return level