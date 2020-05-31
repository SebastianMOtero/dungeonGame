GAME_OBJECT_DEFS = {
	['switch'] = {
		type = 'switch',
		texture = 'switches',
		frame = 2,
		width = 16,
		height = 16,
		solid = false,
		defaultState = 'unpressed',
		states = {
			['unpressed'] = {
				frame = 2
			},
			['pressed'] = {
				frame = 1
			}
		}
	},
	['barrel'] = {
		type = 'barrel',
		texture = 'tiles',
		frame = 110,--math.random(110, 111),
		width = 16,
		height = 16,
		solid = true,
		defaultState = 'barrel',
		states = {
			['barrel'] = {
				frame = 111
			}
		}
	}
}