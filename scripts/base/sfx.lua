local SFX = {}

function SFX.play(...)
	if Audio == nil or arg[1] == nil then return end
	
	if type(arg[1]) ~= 'number' then
		local i = #Audio.sounds + 1
		Audio.sounds[i] = {}
		Audio.sounds[i].sfx = arg[1]
		Audio.sounds[i].volume = arg[2] or 1
		Audio.sounds[i].loops = arg[3] or 1
	end
end

return SFX