local npc = {}

function npc.onTickEndNPC(v)
	v.projectile = false
	if v.despawnTimer > 1 then
		v.despawnTimer = 100
	end
	if v.cantHurt > 0 then
		v.cantHurt = 100
	end
end

return npc