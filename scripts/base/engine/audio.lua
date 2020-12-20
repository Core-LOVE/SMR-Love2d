local sounds = {}
sounds.sounds = {}
sounds.musics = {}
sounds.musics.world = {}
sounds.musics.level = {}
sounds.musics.special = {}

function sounds.loadSounds()
	if ini_parser == nil then return end
	
	local mx = 102
	local sfx = ini_parser.load("sounds.ini")
	
	mx = sfx['sound-main'].total
	for i = 1, mx do
		if i ~= 98 then
			sounds.sounds[i] = {}
			sounds.sounds[i].name = sfx['sound-'..tostring(i)].name
			sounds.sounds[i].sfx = love.audio.newSource("sound/"..sfx['sound-'..tostring(i)].file, 'stream')
			print("sound/"..sfx['sound-'..tostring(i)].file)
		end
	end
	
	-- temp
	-- local w_mx = 17
	-- local l_mx = 59
	-- local s_mx = 3
	-- local mfx = ini_parser.load("music.ini")
	
	-- w_mx = mfx['music-main']['total-world']
	-- l_mx = mfx['music-main']['total-level']
	-- s_mx = mfx['music-main']['total-special']
	
	-- for i = 1, w_mx do
		-- sounds.musics.world[i] = {}
		-- sounds.musics.world[i].name = mfx['world-music-'..tostring(i)].name
		-- sounds.musics.world[i].sfx = mfx['world-music-'..tostring(i)].file
		-- print("music/"..mfx['world-music-'..tostring(i)].file)
	-- end
	-- for i = 1, l_mx do
		-- sounds.musics[i] = {}
		-- sounds.musics[i].name = mfx['level-music-'..tostring(i)].name
		-- sounds.musics[i].sfx = mfx['level-music-'..tostring(i)].file
		-- print("music/"..mfx['level-music-'..tostring(i)].file)
	-- end
	-- for i = 1, s_mx do
		-- sounds.musics.special[i] = {}
		-- sounds.musics.special[i].name = mfx['special-music-'..tostring(i)].name
		-- sounds.musics.special[i].sfx = mfx['special-music-'..tostring(i)].file
		-- print("music/"..mfx['special-music-'..tostring(i)].file)
	-- end
end

return sounds