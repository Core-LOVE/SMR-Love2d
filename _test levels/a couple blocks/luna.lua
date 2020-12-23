require("libraryTest")

function onCameraDraw()
	for k,v in ipairs(NPC.get(22)) do
		Text.print(v.speedX .. " : " .. v.speedY, 10, 10)
	end
end