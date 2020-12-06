local SFX = {}

function SFX.play(sfx)
	if Audio == nil or sfx == nil then return end
	
	if type(sfx) == 'number' then
		love.audio.play(Audio.sounds[sfx].sfx)
	end
end

return SFX