local Section = {__type="Section"}

local SectionFields = {
	idx = 0,
	isValid = false,
	
	boundary = {},
	origBoundary = {},
	musicID = 0,
	musicPath = "",
	wrapH = false,
	wrapV = false,
	hasOffscreenExit = false,
	backgroundID = 0,
	background = nil,
	origBackgroundID = 0,
	noTurnBack = false,
	isUnderwater = false,
	
	settings = {},
	effects = {},
	boundary = newRECT()
}

setmetatable(Section, {__call=function(Section, idx)
	return Section[idx] or Section
end})

-- function Section.createSections(max)
	-- for i = 0, max do
		-- local s = {
			-- idx = i,
			-- isValid = true,
			
			-- musicID = 0,
			-- musicPath = "",
			-- wrapH = false,
			-- wrapV = false,
			-- hasOffscreenExit = false,
			-- backgroundID = 0,
			-- background = nil,
			-- origBackgroundID = 0,
			-- noTurnBack = false,
			-- isUnderwater = false,
			
			-- settings = {},
			-- effects = {},
			-- boundary = newRECT(),
			-- origBoundary = newRECT()
		-- }
		
		-- s.boundary.left = -200000 + (20000 * i)
		-- s.boundary.top = -200600 + (20000 * i)
		-- s.boundary.right = -199200 + (20000 * i)
		-- s.boundary.bottom = -200000 + (20000 * i)
		-- s.origBoundary = s.boundary
		
		-- Section[#Section + 1] = s
	-- end
-- end

function Section.create(ID, bound, musID, musPath, bgID)
	local s = {
		idx = ID,
		isValid = true,
		
		musicID = musID or 0,
		musicPath = musPath or "",
		wrapH = false,
		wrapV = false,
		hasOffscreenExit = false,
		backgroundID = bgID or 0,
		background = nil,
		origBackgroundID = bgID or 0,
		noTurnBack = false,
		isUnderwater = false,
		
		settings = {},
		effects = {},
		boundary = newRECT(),
		origBoundary = newRECT()
	}
	
	s.boundary = bound
	s.origBoundary = bound
	
	Section[#Section + 1] = s
	return s
end

function Section.getIntersecting(x1,y1,x2,y2)
	local ret = {}
	
	for _,v in ipairs(Section) do
		local b = v.boundary
		
		if b.left <= x2 and b.top <= y2 and b.right >= x1 and b.bottom >= y1 then
			ret[#ret + 1] = v
		end
	end

	return ret
end

function Section.count()
	return #Section
end

function Section.get(filter)
	local ret = {}

	for i = 1, #Section do
		if idFilter == nil then
			ret[#ret + 1] = Section(i)
			print(inspect(Section(i)))
		else
			if type(filter) == 'number' then
				local k = filter
				if Section(i).idx == k then
					ret[#ret + 1] = Section(i)
					print(inspect(Section(i)))
				end
			elseif type(filter) == 'table' then
				for k in values(filter) do
					if Section(i).idx == k then
						ret[#ret + 1] = Section(i)
						print(inspect(Section(i)))
					end
				end
			end
		end
	end

	return ret
end

return Section