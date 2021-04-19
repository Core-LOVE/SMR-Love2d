-- copy /b love.exe+smr.love smr.exe

do
    local dir = love.filesystem.getSourceBaseDirectory( )
    local success = love.filesystem.mount(dir, "smr")

    if not success then
		print('not success')
	else
		local r = require
		require = function(path)
			if path ~= 'utf8' and path ~= 'ffi' then
				return r('smr/' .. path)
			else
				return r(path)
			end
		end
	end
end

require 'scripts/base/engine/main'