Room = Class{}

function Room:init(player)
	self.width = ROOM_WIDTH
	self.height = ROOM_HEIGHT

	self.tiles = {}

	self.entities = {}

	self.objects = {}

	self.doorways = {}

	self.player = player

	self.renderOffsetX = MAP_RENDER_OFFSET_X
	self.renderOffsetY = MAP_RENDER_OFFSET_Y
end