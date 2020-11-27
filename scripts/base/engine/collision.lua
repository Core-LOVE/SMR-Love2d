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


COLLISION_SIDE_NONE    = 0
COLLISION_SIDE_TOP     = 1
COLLISION_SIDE_RIGHT   = 2
COLLISION_SIDE_BOTTOM  = 3
COLLISION_SIDE_LEFT    = 4
COLLISION_SIDE_UNKNOWN = 5

function Collision.side(Loc1, Loc2, leniencyForTop)
    if(Loc1.y + Loc1.height - Loc1.speedY <= Loc2.y - Loc2.speedY + leniencyForTop) then
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
    local function getConfig(v,vType)
        if vType == "NPC" then
            return NPC.config[v.id]
        elseif vType == "Block" then
            return Block.config[v.id]
        end
    end


    function Collision.addCollisionProperties(v)
        local vType = v.__type
        
        v.collidingSolids = {}
		v.collidingSolidsSides = {}

		v.collidesBlockBottom = false
		v.collidesBlockLeft = false
		v.collidesBlockRight = false
		v.collidesBlockUp = false
    end

    function Collision.addSolidObjectProperties(v)
        local vType = v.__type

        local config = getConfig(v,vType)

        if vType == "Block" then
            v.solidData = {}

            v.solidData.passthrough = config.passthrough
            v.solidData.semisolid = (config.semisolid or config.sizeable) and not v.solidData.passthrough

            v.solidData.floorSlope = config.floorslope
            v.solidData.ceilingSlope = config.ceilingSlope

            v.solidData.solid = (not v.solidData.passthrough and not v.solidData.semisolid)
        elseif vType == "NPC" then
            v.solidData = {passthrough = true}
        end
    end

    local function clamp(val,min,max)
        return math.max(math.min(val,max),min)
    end


    local function getSlopeEjectionPosition(v,vType,solid,solidData)
        if solidData.floorSlope ~= 0 then
            local vSide     = (v.x    +(v.width    *0.5))-((v.width    *0.5)*solidData.floorSlope)
            local solidSide = (solid.x+(solid.width*0.5))+((solid.width*0.5)*solidData.floorSlope)

            local distance = (solidSide-vSide)*solidData.floorSlope

            return (solid.y+solid.height) - (clamp(distance/solid.width,0,1) * solid.height)
        end
    end

    local function hitSolid(v,vType,solid)
        local side = Collision.side(v,solid,0.5)

        local solidData = solid.solidData


        local slopeEjectionPosition
        if solidData.floorSlope ~= 0 then
            if side == COLLISION_SIDE_TOP or (solidData.floorSlope == -1 and side == COLLISION_SIDE_LEFT) or (solidData.floorSlope == 1 and side == COLLISION_SIDE_RIGHT) or side == COLLISION_SIDE_UNKNOWN then
                slopeEjectionPosition = getSlopeEjectionPosition(v,vType,solid,solidData)
                
                if v.y+v.height-v.speedY <= slopeEjectionPosition+1.5 and v.y+v.height+v.speedY >= slopeEjectionPosition-2 then
                    side = COLLISION_SIDE_TOP
                else
                    side = COLLISION_SIDE_NONE
                end
            end
        end


        if solidData.passthrough or (side ~= COLLISION_SIDE_TOP and solidData.semisolid) then
            side = COLLISION_SIDE_NONE
        end


        if side == COLLISION_SIDE_LEFT or side == COLLISION_SIDE_RIGHT then
            if vType == "NPC" then
                v.turnAround = true
            else
                v.speedX = 0
            end
        elseif side == COLLISION_SIDE_TOP or side == COLLISION_SIDE_BOTTOM then
            v.speedY = 0
        end

        -- Ejection
        if side == COLLISION_SIDE_TOP then
            if slopeEjectionPosition == nil then
                v.y = solid.y-v.height
            else
                v.y = slopeEjectionPosition-v.height
            end

            v.collidesBlockBottom = true
        elseif side == COLLISION_SIDE_RIGHT then
            v.x = solid.x+solid.width
            v.collidesBlockLeft = true
        elseif side == COLLISION_SIDE_BOTTOM then
            v.y = solid.y+solid.height
            v.collidesBlockUp = true
        elseif side == COLLISION_SIDE_LEFT then
            v.x = solid.x-v.width
            v.collidesBlockRight = true
        end


        table.insert(v.collidingSolids,solid)
        table.insert(v.collidingSolidsSides,side)
    end


    function Collision.applySpeedWithCollision(v)
        local vType = v.__type

        -- Reset collision fields
        for i=1,#v.collidingSolids do
            v.collidingSolids[i] = nil
            v.collidingSolidsSides[i] = nil
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
            hitSolid(v,vType,block)
        end
    end
end


return Collision