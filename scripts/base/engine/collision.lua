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

function Collision.shouldTurnAround(Loc1, Loc2, Direction, Section)
	if(Loc1.y + Loc1.height + 8 <= Loc2.y + Loc2.height) then
        if(Loc1.y + Loc1.height + 8 >= Loc2.y) then
            if(Loc1.x + Loc1.width * 0.5 + (8 * Direction) <= Loc2.x + Loc2.width) then            
                if(Loc1.x + Loc1.width * 0.5 + (8 * Direction) >= Loc2.x) then
                    if(Loc2.y > Loc1.y + Loc1.height - 8) then
                        return false
                    end
                end
            end
        end
    end
	
	return true
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
    leniencyForTop = leniencyForTop or 0
    
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
    function Collision.addCollisionProperties(v)
        local vType = v.__type
        
        v.collidingSolids = {}
        v.collidingSolidsSides = {}
        
        v.collidingSlope = nil

		v.collidesBlockBottom = false
		v.collidesBlockLeft = false
		v.collidesBlockRight = false
        v.collidesBlockUp = false
    end

    function Collision.addSolidObjectProperties(v)
        local vType = v.__type

        v.solidData = {}

        if vType == "Block" then
            local config = Block.config[v.id]

            v.solidData.passthrough = config.passthrough
            v.solidData.semisolid = (config.semisolid or config.sizable) and not v.solidData.passthrough

            v.solidData.floorSlope = config.floorslope
            v.solidData.ceilingSlope = config.ceilingslope

            v.solidData.solid = (not v.solidData.passthrough and not v.solidData.semisolid)
        elseif vType == "NPC" then
            local config = NPC.config[v.id]

            v.solidData.passthrough = (not config.playerblock and not config.playerblocktop)
            v.solidData.semisolid = (config.playerblocktop and not v.solidData.passthrough)

            v.solidData.solid = (not v.solidData.passthrough and not v.solidData.semisolid)
        end
    end

    local function clamp(val,min,max)
        return math.max(math.min(val,max),min)
    end


    local function getSlopeData(solidData)
        if solidData.floorSlope ~= 0 then
            return solidData.floorSlope,    COLLISION_SIDE_TOP   ,false
        elseif solidData.ceilingSlope ~= 0 then
            return -solidData.ceilingSlope, COLLISION_SIDE_BOTTOM,true
        end
    end

    local function getSlopeEjectionPosition(v,vType,solid,solidData,slopeDirection)
        local vSide     = (v.x    +(v.width    *0.5))-((v.width    *0.5)*slopeDirection)
        local solidSide = (solid.x+(solid.width*0.5))+((solid.width*0.5)*slopeDirection)

        local distance = (solidSide-vSide)*slopeDirection

        if solidData.floorSlope ~= 0 then
            return (solid.y+solid.height) - (clamp(distance/solid.width,0,1) * solid.height) - v.height
        elseif solidData.ceilingSlope ~= 0 then
            return solid.y + (clamp(distance/solid.width,0,1) * solid.height)
        end
    end

    local function hitSolid(v,vType,solid)
        local side = Collision.side(v,solid,0.5)

        local solidData = solid.solidData

        
        -- Slope handling
        if v.collidingSlope ~= nil and solidData.floorSlope == 0 and solidData.ceilingSlope == 0 then
            return
        end

        local slopeDirection,slopeEjectSide,ceiling = getSlopeData(solidData)
        local slopeEjectionPosition

        if slopeDirection ~= nil then
            if side == slopeEjectSide or side == COLLISION_SIDE_UNKNOWN or (slopeDirection == -1 and side == COLLISION_SIDE_LEFT) or (slopeDirection == 1 and side == COLLISION_SIDE_RIGHT) then
                slopeEjectionPosition = getSlopeEjectionPosition(v,vType,solid,solidData,slopeDirection)

                local topLeniency = 1.5
                local bottomLeniency = -2
                local positionCheckSpeed = v.speedY * ((ceiling and -1) or 1)
                
                if slopeEjectionPosition ~= nil and (v.collidingSlope == nil or solidData.ceilingSlope == 0 or solid.y >= v.collidingSlope.y+v.collidingSlope.height) and v.y-positionCheckSpeed <= slopeEjectionPosition+topLeniency and v.y+positionCheckSpeed >= slopeEjectionPosition+bottomLeniency then
                    side = slopeEjectSide
                else
                    side = COLLISION_SIDE_NONE
                end
            end
        end


        if solidData.passthrough or (side ~= COLLISION_SIDE_TOP and solidData.semisolid) or (NPC.config[v.id] ~= nil and NPC.config[v.id].noblockcollision) then
            side = COLLISION_SIDE_NONE
        end


        -- Effects
        if side == COLLISION_SIDE_LEFT or side == COLLISION_SIDE_RIGHT then
            if vType == "NPC" then
                v.turnAround = true
            else
                v.speedX = 0
            end
        elseif side == COLLISION_SIDE_TOP or side == COLLISION_SIDE_BOTTOM then
            if solidData.collidingSlope == 0 then
                v.speedY = 0
            else
                v.speedY = 1
            end

            if vType == "Player" then
                v.jumpForce = 0
            end
        end

        if side == COLLISION_SIDE_BOTTOM and vType == "Player" then
            SFX.play(3)
        end


        -- Ejection
        if side == COLLISION_SIDE_TOP then
            if slopeEjectionPosition == nil then
                v.y = solid.y-v.height
            else
                v.y = slopeEjectionPosition
                v.collidingSlope = solid
            end

            v.collidesBlockBottom = true
        elseif side == COLLISION_SIDE_RIGHT then
            v.x = solid.x+solid.width
            v.collidesBlockLeft = true
        elseif side == COLLISION_SIDE_BOTTOM then
            if slopeEjectionPosition == nil then
                v.y = solid.y+solid.height
            else
                v.y = slopeEjectionPosition
                v.collidingSlope = solid
            end

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

        v.collidingSlope = nil

        v.collidesBlockBottom = false
		v.collidesBlockLeft = false
		v.collidesBlockRight = false
        v.collidesBlockTop = false
        


        v.x = v.x + v.speedX
        v.y = v.y + v.speedY

        -- Interact with blocks
        for _,block in Block.iterateIntersecting(v.x,v.y,v.x+v.width,v.y+v.height) do
            hitSolid(v,vType,block)
        end

        for _,npc in NPC.iterateIntersecting(v.x,v.y,v.x+v.width,v.y+v.height) do
            hitSolid(v,vType,npc)
        end
    end
end


return Collision