local Warp = {__type="Warp"}

setmetatable(Warp, {__call=function(Warp, idx)
	return Warp[idx] or Warp
end})


function Warp.create(type, enX, enY, exX, exY)
	local w = {
		idx = #Warp + 1,
		warpType = type,
		
		entranceX = enX,
		entranceY = enY,
		exitX = exX,
		exitY = exY,
		entranceWidth = 32,
		entranceHeight = 32,
		exitWidth = 32,
		exitHeight = 32,
		entranceSpeedX = 0,
		entranceSpeedY = 0,
		exitSpeedX = 0,
		exitSpeedy = 0,
		entranceDirection = 1,
		exitDirection = 1,	
		
		layer = "",
		isHidden = false,
	}

	for _,s in ipairs(Section.getIntersecting(enX, enY, enX + 32, enY + 32)) do
		w.entranceSection = s.idx
	end
	
	for _,s in ipairs(Section.getIntersecting(exX, exY, exX + 32, exY + 32)) do
		w.exitSection = s.idx
	end
	
	Warp[#Warp + 1] = w
	return w
end

return Warp 