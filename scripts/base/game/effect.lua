-- Very, very much based on bettereffects from smbx2.

local Effect = {}


EFFECT_MAX_ID = 1000


Effect.config = require("game/effectConfig")



function Effect.load()
    Effect.config.load()
end


Effect.spawners = {}
Effect.objs = {}

function Effect.spawn(id,x,y,variant,npcID,shadow)
    -- Create a spawner
    local spawner = {}

    if type(x) ~= "number" then
        spawner.parent = {x = x.x+(x.width*0.5),y = x.y+(x.height*0.5),width = x.width,height = x.height,speedX = x.speedX,speedY = x.speedY,ref = x}
        spawner.variant = y
        spawner.npcID = variant or 0
        spawner.shadow = npcID or false
    else
        spawner.parent = {x = x,y = y,width = 0,height = 0,speedX = 0,speedY = 0,ref = nil}
        spawner.variant = variant
        spawner.npcID = npcID or 0
        spawner.shadow = shadow or false
    end


    spawner.id = id

    local totalConfig = Effect.config[spawner.id]

    spawner.x = spawner.parent.x
    spawner.y = spawner.parent.y
    spawner.width  = totalConfig[1].width
    spawner.height = totalConfig[1].height
    spawner.speedX = nil
    spawner.speedY = nil

    spawner.timer = 0
    spawner.toRemove = false


    spawner.objSpawnTimes = {}
    spawner.maxDelay = 0

    for objIndex,objConfig in ipairs(totalConfig) do
        spawner.objSpawnTimes[objConfig.delay] = spawner.objSpawnTimes[objConfig.delay] or {}
        table.insert(spawner.objSpawnTimes[objConfig.delay],objIndex)

        spawner.maxDelay = math.max(spawner.maxDelay,objConfig.delay)
    end

    table.insert(Effect.spawners,spawner)
	return spawner
end



local function chooseFromRange(value)
    if type(value) ~= "number" then
        return love.math.random(value[1],value[2])
    else
        return value
    end
end

local copyFromSpawnerOrConfig = {
    "priority","lifetime","animationFrame","animationTimer","frames","framestyle","framespeed","npcID","variant","variants","shadow",
    "accelerationX","accelerationY","gravity",
}

local function spawnEffectObj(spawner,iteration)
    local obj = {}

    local configFromSpawner = Effect.config[spawner.id][iteration]

    obj.id = configFromSpawner.spawnID or spawner.id
    obj.iteration = iteration

    local configFromEffect = Effect.config[obj.id][iteration] or Effect.config[obj.id][1]

    for _,name in ipairs(copyFromSpawnerOrConfig) do
        obj[name] = spawner[name] or configFromSpawner[name]
    end


    obj.x = spawner.x + chooseFromRange(spawner.xOffset or configFromSpawner.xOffset)
    obj.y = spawner.y + chooseFromRange(spawner.yOffset or configFromSpawner.yOffset)

    obj.width  = configFromEffect.width
    obj.height = configFromEffect.height

    obj.speedX = chooseFromRange(spawner.speedX or configFromSpawner.speedX)
    obj.speedY = chooseFromRange(spawner.speedY or configFromSpawner.speedY)

    obj.maxSpeedX = chooseFromRange(spawner.maxSpeedX or configFromSpawner.maxSpeedX)
    obj.maxSpeedY = chooseFromRange(spawner.maxSpeedY or configFromSpawner.maxSpeedY)

    obj.angle = chooseFromRange(spawner.angle or configFromSpawner.angle)
    obj.rotation = chooseFromRange(spawner.rotation or configFromSpawner.rotation)

    obj.isHidden = false

    obj.timer = obj.lifetime
    obj.parent = spawner.parent

    obj.render = Effect.render


    obj.onInit = Effect.config.onInit[spawner.onInit or configFromSpawner.onInit]
    obj.onTick = Effect.config.onTick[spawner.onTick or configFromSpawner.onTick]
    obj.onDeath = Effect.config.onDeath[spawner.onDeath or configFromSpawner.onDeath]


    table.insert(Effect.objs,obj)


    if obj.onInit ~= nil then
        obj:onInit()
    end
end


function Effect.update()
    if Defines.levelFreeze then
        return
    end

    -- Update spawners
    for i = #Effect.spawners, 1, -1 do
        local spawner = Effect.spawners[i]

        local totalConfig = Effect.config[spawner.id]
        local spawns = spawner.objSpawnTimes[spawner.timer]

        if spawns ~= nil then
            for _,index in ipairs(spawns) do
                spawnEffectObj(spawner,index)
            end
        end

        spawner.timer = spawner.timer + 1


        if spawner.timer > spawner.maxDelay then
            table.remove(Effect.spawners,i)
        end
    end

    -- Update the actual objects
    for i = #Effect.objs, 1, -1 do
        local obj = Effect.objs[i]

        obj.speedX = obj.speedX + obj.accelerationX
        obj.speedY = obj.speedY + obj.accelerationY + obj.gravity

        if obj.maxSpeedX >= 0 then
            obj.speedX = math.clamp(obj.speedX,-obj.maxSpeedX,obj.maxSpeedX)
        end
        if obj.maxSpeedY >= 0 then
            obj.speedY = math.clamp(obj.speedY,-obj.maxSpeedY,obj.maxSpeedY)
        end


        obj.x = obj.x + obj.speedX
        obj.y = obj.y + obj.speedY


        if obj.framespeed > 0 then
            if obj.animationTimer >= obj.framespeed then
                obj.animationFrame = (obj.animationFrame + 1) % obj.frames
                obj.animationTimer = 0
            end

            obj.animationTimer = obj.animationTimer + 1
        end


        if obj.onTick ~= nil then
            obj:onTick()
        end

        obj.timer = obj.timer - 1

        if obj.timer <= 0 then
            if obj.onDeath ~= nil then
                obj:onDeath()
            end

            table.remove(Effect.objs,i)
        end
    end
end


local framestyleEffect = {[0] = 1,[1] = 2,[2] = 4}
function Effect:render(args)
    if not args.ignorestate and self.isHidden then return end

    local texture = args.texture or Graphics.sprites.effect[self.id].img

    local x = args.x or self.x
    local y = args.y or self.y

    local frame = (args.animationFrame or args.frame or self.animationFrame)
    if self.framestyle > 0 and self.direction == 1 then
        frame = frame + self.frames
    end

    frame = frame + (self.frames*framestyleEffect[self.framestyle]*(self.variant-1))

    Graphics.drawImageToSceneWP(texture,x-(self.width*0.5),y-(self.height*0.5),0,frame*self.height,self.width,self.height,self.priority)
end


return Effect