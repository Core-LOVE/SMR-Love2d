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


COLLISION_SIDE_TOP     = 1
COLLISION_SIDE_RIGHT   = 2
COLLISION_SIDE_BOTTOM  = 3
COLLISION_SIDE_LEFT    = 4
COLLISION_SIDE_UNKNOWN = 5

function Collision.side(Loc1, Loc2, section)
    if(Loc1.y + Loc1.height - Loc1.speedY <= Loc2.y - Loc2.speedY) then
        return COLLISION_SIDE_TOP
    elseif(Loc1.x - Loc1.speedX >= Loc2.x + Loc2.width - Loc2.speedX) then
        return COLLISION_SIDE_RIGHT
    elseif(Loc1.x + Loc1.width - Loc1.speedX <= Loc2.x - Loc2.speedX) then
        return COLLISION_SIDE_LEFT
    elseif(Loc1.y - Loc1.speedY > Loc2.y + Loc2.height - Loc2.speedY - 0.1) then
        return COLLISION_SIDE_BOTTOM
    else
        return COLLISION_SIDE_UNKNOWN
	end
end


-- Actual collision stuff, shared by NPC's and players
do
    function Collision.addCollisionProperties(v)
        local vType = type(v)
        
        v.collidingBlocks = {}
		v.collidingBlocksSides = {}

		v.collidesBlockBottom = false
		v.collidesBlockLeft = false
		v.collidesBlockRight = false
		v.collidesBlockTop = false
    end

    function Collision.addSolidvectProperties(v)
        local vType = type(v)
    end


    local function hitSolid(v,vType,block,side)
        if side == COLLISION_SIDE_LEFT or side == COLLISION_SIDE_RIGHT then
            if vType == "NPC" then
                v.turnAround = true
            else
                v.speedX = 0
            end
        elseif side == COLLISION_SIDE_TOP or side == COLLISION_SIDE_BOTTOM then
            v.speedY = 0
        end
    end


    local ejectionFunctions = {}

    ejectionFunctions[COLLISION_SIDE_TOP] = (function(v,vType,block)
        v.y = block.y - v.height
    end)
    ejectionFunctions[COLLISION_SIDE_RIGHT] = (function(v,vType,block)
        v.x = block.x + block.width
    end)
    ejectionFunctions[COLLISION_SIDE_BOTTOM] = (function(v,vType,block)
        v.y = block.y + block.height
    end)
    ejectionFunctions[COLLISION_SIDE_LEFT] = (function(v,vType,block)
        v.x = block.x - v.width
    end)
    ejectionFunctions[COLLISION_SIDE_UNKNOWN] = (function(v,vType,block)
        
    end)


    function Collision.applySpeedWithCollision(v)
        local vType = v.__type

        -- Reset collision fields
        for i=1,#v.collidingBlocks do
            v.collidingBlocks[i] = nil
            v.collidingBlocksSides[i] = nil
        end

        v.collidesBlockBottom = false
		v.collidesBlockLeft = false
		v.collidesBlockRight = false
        v.collidesBlockTop = false
        


        v.x = v.x + v.speedX
        v.y = v.y + v.speedY

        -- Interact with blocks
        for _,block in Block.iterateIntersecting(v.x,v.y,v.x+v.width,v.y+v.height) do
            -- Get side
            local side = Collision.side(v,block)

            hitSolid(v,vType,block,side)

            ejectionFunctions[side](v,vType,block)


            table.insert(v.collidingBlocks,block)
            table.insert(v.collidingBlocksSides,side)
        end
    end
end


return Collision