local SFX = {
	defaultDelay = {},
	delay = {}
}
for i = 1, 100 do
	SFX.defaultDelay[i] = 0
	SFX.delay[i] = 0
end

SFX.defaultDelay[10] = 8

for k,v in ipairs(SFX.delay) do
	print("SFX.delay["..k.."] = "..v)
end

function SFX.onInitAPI()
	registerEvent(SFX, "onTick", "update")
end

function SFX.play(sfx)
	if type(sfx) == 'number' and SFX.delay[sfx] <= 0 then
		Audio.sounds[sfx].sfx:stop()
		Audio.sounds[sfx].sfx:play()
		SFX.delay[sfx] = SFX.defaultDelay[sfx]
	end
end

function SFX.update()
	for k = 1, #SFX.delay do
		if SFX.delay[k] > 0 then
			SFX.delay[k] = SFX.delay[k] - 1
		end
	end
end

return SFX