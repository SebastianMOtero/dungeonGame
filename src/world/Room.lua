Room = Class{}

function Room:init(player)
	self.width = MAP_WIDTH
	self.height = MAP_HEIGHT

	self.tiles = {}
	self:generateWallsAndFloors()

	self.entities = {}

	self.objects = {}
	self:generateObjects()

	local doorsDirection = {'top', 'right', 'bottom', 'left'}

	self.openDoor = 'nil'
	self.doorways = {}
	for k, direction in pairs(doorsDirection) do
		if self.openDoor == direction or math.random(2) == 1 then
			table.insert(self.doorways, Doorway(direction, self.openDoor == direction, self))
		end
	end
	self.player = player

	self.renderOffsetX = MAP_RENDER_OFFSET_X
	self.renderOffsetY = MAP_RENDER_OFFSET_Y

	self.adjacentOffsetX = 0
	self.adjacentOffsetY = 0
end

function Room:generateWallsAndFloors()
	for y = 1, self.height do
		table.insert(self.tiles, {})

		for x = 1, self.width do
			local id = TILE_EMPTY

			if x == 1 and y == 1 then
				id = TILE_TOP_LEFT_CORNER
			elseif x == 1 and y == self.height then
				id = TILE_BOTTOM_LEFT_CORNER
			elseif x == self.width and y == 1 then
				id = TILE_TOP_RIGHT_CORNER
			elseif x == self.width and y == self.height then
				id = TILE_BOTTOM_RIGHT_CORNER
			elseif x == 1 then
				id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
			elseif x == self.width then
				id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
			elseif y == 1 then
				id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
			elseif y == self.height then
				id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
			else
				id = TILE_FLOORS[math.random(#TILE_FLOORS)]
			end

			table.insert(self.tiles[y], {
				id = id
			})
		end
	end
end

function Room:generateObjects()
	local switch = GameObject(
		GAME_OBJECT_DEFS['switch'],
		math.random(MAP_RENDER_OFFSET_X + TILE_SIZE, VIRTUAL_WIDTH - TILE_SIZE * 3),
		math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
	)

	switch.onCollide = function()
		if switch.state == 'unpressed' then
			switch.state = 'pressed'
		end
	end
	table.insert(self.objects, switch)
end

function Room:update(dt)
	self.player:update(dt)

	for k, object in pairs(self.objects) do
		object:update(dt)

		if self.player:collides(object) then
			object:onCollide()
		end
	end
end

function Room:render()

	--render floor
	for y = 1, self.height do
		for x = 1, self.width do
			local tile = self.tiles[y][x]
			love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id], (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
		end
	end

	--render doors
	for k, doorway in pairs(self.doorways) do
		doorway:render()
	end

	--render objects
	for k, object in pairs(self.objects) do
		object:render()
	end

	if self.player then
		self.player:render()
	end
end