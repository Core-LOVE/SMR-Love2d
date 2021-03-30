local Anim = {
	_VERSION = 1.0
}

function Anim.new()
	local v = {}
	
	v.frame = 0
	v.frametimer = 0
	v.framedelay = 8
	
	v.current_state = ''
	
	v.xOffset = 0
	v.yOffset = 0
	
	setmetatable(v, {__index = Anim})
	return v
end

function Anim:update()
	local a = self
	local v = self[self.current_state]
	
	a.frametimer = (a.frametimer) + 1
	if a.frametimer >= a.framedelay then
		a.frame = (a.frame + 1) % #v
		a.frametimer = 0
		
		return v[a.frame]
	end
	
	return false
end

function Anim:defineState(name, state)
	local v = self
	return function(state)
		v[name] = state
	end
end

function Anim:setState(name)
	if self.current_state == name or not self[name] then return end
	local v = self
	
	v.framedelay = v[name].framedelay or 8
	v.frame = v[name][1] or 0
	
	v.current_state = name
end

return Anim