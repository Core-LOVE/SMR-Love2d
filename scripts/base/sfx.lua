local SFX = {}

function SFX.play(sfx)
	if Audio == nil or sfx == nil then return end
	
	if type(sfx) == 'number' then
		Audio.sounds[sfx].sfx:stop()
		Audio.sounds[sfx].sfx:play()
	end
end

return SFX