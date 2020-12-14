local HUDOverride = {}

HUDOverride.ALIGN_LEFT = 0
HUDOverride.ALIGN_RIGHT = 1
HUDOverride.ALIGN_MID = 0.5

HUDOverride.priority = 4.999999


HUDOverride.visible = {}
HUDOverride.visible.keys = true
HUDOverride.visible.itembox = true
HUDOverride.visible.bombs = true
HUDOverride.visible.coins = true
HUDOverride.visible.score = true
HUDOverride.visible.lives = true
HUDOverride.visible.stars = true
HUDOverride.visible.advancedcoins = true
HUDOverride.visible.timer = true

HUDOverride.visible.levelname = true
HUDOverride.visible.overworldPlayer = true
HUDOverride.visible.overworld = {}
HUDOverride.visible.overworld.player = true
HUDOverride.visible.overworld.player2 = true
HUDOverride.visible.overworld.stars = true
HUDOverride.visible.overworld.coins = true
HUDOverride.visible.overworld.lives = true

HUDOverride.offsets = {}
HUDOverride.offsets.keys = 		{x = 64, 	y = 26, align = HUDOverride.ALIGN_LEFT}
HUDOverride.offsets.itembox = 	{x = 0, 	y = 16, item = {x = 28, y = 28, align = HUDOverride.ALIGN_MID}, align = HUDOverride.ALIGN_MID}
HUDOverride.offsets.hearts = 	{x = 5, 	y = 16, align = HUDOverride.ALIGN_MID}
HUDOverride.offsets.score = 	{x = 170, 	y = 47, align = HUDOverride.ALIGN_RIGHT}

HUDOverride.offsets.bombs = 	{x = 0, 	y = 52, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_MID}
HUDOverride.offsets.coins = 	{x = 88, 	y = 26, cross = {x = 24, y = 1}, value = {x = 82, y = 1, align = HUDOverride.ALIGN_RIGHT}, align = HUDOverride.ALIGN_LEFT}
HUDOverride.offsets.lives = 	{x = -166, 	y = 26, cross = {x = 40, y = 1}, value = {x = 62, y = 1, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT}
HUDOverride.offsets.stars = 	{x = -150, 	y = 46, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT}
HUDOverride.offsets.timer = {x = 264, y = 25, cross = {x = 24, y = 2},	value = {x = 106, y = 2, align = HUDOverride.ALIGN_RIGHT}, align = HUDOverride.ALIGN_LEFT}

HUDOverride.overworld = {offsets = {}}
HUDOverride.overworld.offsets.lives = 		{x = -272, 	y = 110, cross = {x = 40, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 62, y = 2, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT}
HUDOverride.overworld.offsets.coins = 		{x = -256, 	y = 88, cross = {x = 24, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 46, y = 2, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT}
HUDOverride.overworld.offsets.stars = 		{x = -256, 	y = 66, cross = {x = 24, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 46, y = 2, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT}
HUDOverride.overworld.offsets.levelname = 	{x = -156, 	y = 109, p2Offset = {x = 48, y = 0}, align = HUDOverride.ALIGN_LEFT}
HUDOverride.overworld.offsets.player =		{x = -308, y = 124}
HUDOverride.overworld.offsets.player2 =		{x = -308+48, y = 124}

return HUDOverride