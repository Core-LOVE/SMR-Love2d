local Collision = {}

function Collision.check(Loc1, Loc2, section) --simple collision check
    if(Loc1.y + Loc1.height >= Loc2.y) then
        if(Loc1.y <= Loc2.y + Loc2.height) then
            if(Loc1.x <= Loc2.x + Loc2.width) then
                if(Loc1.x + Loc1.width >= Loc2.x) then
                    return true
                end
            end
        end
    end
	
	return false
end

function Collision.checkWithSpeed(Loc1, Loc2) --check collision with speed
    if(Loc1.y + Loc1.height + Loc1.speedY >= Loc2.y + Loc2.speedY) then
        if(Loc1.y + Loc1.speedY <= Loc2.y + Loc2.height + Loc2.speedY) then 
            if(Loc1.x + Loc1.speedX <= Loc2.x + Loc2.width + Loc2.speedX) then
                if(Loc1.x + Loc1.width + Loc1.speedX >= Loc2.x + Loc2.speedX) then
                    return true
                end
            end
        end
    end
	
	return false
end

function Collision.rails(Loc1, BG, section)
    local tempRailCollision = false
    local Loc2 = BG

    if(BG.id == 71 or BG.id == 72 or BG.id == 73 or BG.id == 74 or BG.id == 70) then
        return Collision.check(Loc1, Loc2, section)
	end
	
    for x = -1, 1 do
        for y = -1, 1 do
            local tempPoint = Loc1.x + Loc1.width/2 + Loc1.speedX*x - Loc2.x
            if(BG.id == 212 or BG.id == 210 or BG.id == 214) then
                tempPoint = tempPoint * Loc2.height / Loc2.width
            elseif(BG.id == 211 or BG.id == 209 or BG.id == 213) then
                tempPoint = Loc2.height - tempPoint * Loc2.height / Loc2.width
			end

            if(Loc1.y + Loc1.height + Loc1.speedY*y >= Loc2.y + tempPoint - 1 + Loc2.speedY*y) then
                if(Loc1.y + Loc1.speedY*y <= Loc2.y + tempPoint + 1 + Loc2.speedY*y) then
                    if(Loc1.x + Loc1.speedX*x <= Loc2.x + Loc2.width + Loc2.speedX*x) then
                        if(Loc1.x + Loc1.speedX*x + Loc1.width >= Loc2.x + Loc2.speedX*x) then
                            tempRailCollision = true
                            return tempRailCollision
                        end
                    end
                end
            end
        end
    end
	
    return tempRailCollision
end

function Collision.railsWS(Loc1, BG, section)
    local tempRailSpeedCollision = false
    local Loc2 = BG.Location

    if(BG.id == 71 or BG.id == 72 or BG.id == 73 or BG.id == 74) then
        return CheckCollision(Loc1, Loc2, section)
	end

    local tempPoint = Loc1.x + Loc1.speedX + Loc1.width/2 - Loc2.x - Loc2.speedX
    if(BG.id == 212 or BG.id == 210) then
        tempPoint = tempPoint * Loc2.height / Loc2.width
    elseif(BG.id == 211 or BG.id == 209) then
        tempPoint = Loc2.height - tempPoint * Loc2.height / Loc2.width
	end

    if(Loc1.y + Loc1.height + Loc1.speedY >= Loc2.y + tempPoint + Loc2.speedY) then
        if(Loc1.y - Loc1.height + Loc1.speedY <= Loc2.y + tempPoint + Loc2.speedY) then
            if(Loc1.x + Loc1.speedX <= Loc2.x + Loc2.width + Loc2.speedX) then
                if(Loc1.x + Loc1.width + Loc1.speedX >= Loc2.x + Loc2.speedX) then
                    tempRailSpeedCollision = true
                    return tempRailSpeedCollision
                end
            end
        end
    end
	
    return tempRailSpeedCollision
end

function Collision.n00b(Loc1, Loc2, section)
    local tempn00bCollision = false
    local EZ = 2
	
    if(Loc2.width >= 32 - EZ * 2 and Loc2.height >= 32 - EZ * 2) then
        if(Loc1.y + Loc1.height - EZ >= Loc2.y) then
            if(Loc1.y + EZ <= Loc2.y + Loc2.height) then
                if(Loc1.x + EZ <= Loc2.x + Loc2.width) then
                    if(Loc1.x + Loc1.width - EZ >= Loc2.x) then
                        tempn00bCollision = true
                        return tempn00bCollision
                    end
                end
            end
        end
    else
        if(Loc1.y + Loc1.height >= Loc2.y) then 
            if(Loc1.y <= Loc2.y + Loc2.height) then
                if(Loc1.x <= Loc2.x + Loc2.width) then
                    if(Loc1.x + Loc1.width >= Loc2.x) then
                        tempn00bCollision = true
                        return tempn00bCollision
                    end
                end
            end
        end
    end
end

function Collision.npcStart(Loc1, Loc2, section) --sed when a NPC is activated to see if it should spawn
	if(Loc1.x < Loc2.x + Loc2.width) then
        if(Loc1.x + Loc1.width > Loc2.x) then
            if(Loc1.y < Loc2.y + Loc2.height) then
                if(Loc1.y + Loc1.height > Loc2.y) then
                    return true
                end
            end
        end
    end
	
	return false
end

function Collision.warp(Loc1, A, section) --not complete port!
    local tempWarpCollision = false
    local x2 = 0
    local y2 = 0

    local tempVar = Warp(A)
    if(tempVar.direction == 3) then
        x2 = 0
        y2 = 32
    elseif(tempVar.direction == 1) then  
        x2 = 0
        y2 = -30
    elseif(tempVar.direction == 2) then
        x2 = -31
        y2 = 32
    elseif(tempVar.direction == 4) then
        x2 = 31
        y2 = 32
    end

    if(Loc1.x <= tempVar.entranceX + tempVar.entranceWidth + x2) then
        if(Loc1.x + Loc1.width >= tempVar.entranceX + x2) then
            if(Loc1.y <= tempVar.entranceY + tempVar.entranceHeight + y2) then         
                if(Loc1.y + Loc1.height >= tempVar.entranceY + y2) then      
                    tempWarpCollision = true
                    return tempWarpCollision
                end
            end
        end
    end
end

function Collision.side(Loc1, Loc2, section)
    local tempFindCollision = 5
	
    if(Loc1.y + Loc1.height - Loc1.speedY <= Loc2.y - Loc2.speedY) then
        tempFindCollision = 1
    elseif(Loc1.x - Loc1.speedX >= Loc2.x + Loc2.width - Loc2.speedX) then
        tempFindCollision = 2
    elseif(Loc1.x + Loc1.width - Loc1.speedX <= Loc2.x - Loc2.speedX) then
        tempFindCollision = 4
    elseif(Loc1.y - Loc1.speedY > Loc2.y + Loc2.height - Loc2.speedY - 0.1) then
        tempFindCollision = 3
	end
	
	return tempFindCollision
end


function Collision.applySpeedWithCollision(obj)
    local objType = type(obj)

    
end

return Collision