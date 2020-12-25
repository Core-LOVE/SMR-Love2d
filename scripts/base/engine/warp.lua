local Warp = {__type="Warp"}

setmetatable(Warp, {__call=function(Warp, idx)
	return Warp[idx] or Warp
end})


function Warp.create(type, enX, enY, exX, exY)
	local w = {
		__type = Warp.__type,
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

function Warp.getIntersectingEntrance(x1, y1, x2, y2)
	local ret = {}

	for _,v in ipairs(Warp) do
		if v.entranceX <= x2 and v.entranceY <= y2 and v.entranceX + v.entranceWidth >= x1 and v.entranceY + v.entranceHeight >= y1 then
			ret[#ret + 1] = v
		end
	end

	return ret
end

return Warp 