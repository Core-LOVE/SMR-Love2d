function onCameraDraw()
	for k,v in ipairs(NPC.get()) do
		Text.print(v.speedY, 10, 10)
	end
end
