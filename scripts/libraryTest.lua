local lib = {}


function lib.onInitAPI()
    registerEvent(lib,"onTick")
end

function lib.onTick()
    if Player(1).keys.dropItem == KEYS_PRESSED then
        Player(1).speedY = -20
    end
end


return lib

