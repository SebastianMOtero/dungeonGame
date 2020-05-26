Dungeon = Class{}

function Dungeon:init(player)
	self.player = player

	self.rooms = {}

	self.currentRoom = Room(self.player, nil)

	self.nextRoom = nil

	self.cameraX = 0
	self.cameraY = 0
	self.shifting = false

	Event.on('shift-left', function(doorway)
		self:beginShifting(-VIRTUAL_WIDTH, 0, doorway, 'right')
	end)

	Event.on('shift-right', function(doorway)
		self:beginShifting(VIRTUAL_WIDTH, 0, doorway, 'left')
	end)

	Event.on('shift-up', function(doorway)
		self:beginShifting(0, -VIRTUAL_HEIGHT, doorway, 'bottom')
	end)

	Event.on('shift-down', function(doorway)
		self:beginShifting(0, VIRTUAL_HEIGHT, doorway, 'top')
	end)
end

function Dungeon:beginShifting(shiftX, shiftY, doorway, openDoor)
	self.shifting = true
	-- if doorwayAux.direction == 'top' or doorwayAux.direction == 'bottom' then
	-- 	return
	-- end
	self.nextRoom = Room(self.player, openDoor)

	local playerX, playerY = self.player.x, self.player.y
	local openDoor

	if shiftX > 0 then --right room
		playerX = VIRTUAL_WIDTH + (MAP_RENDER_OFFSET_X + TILE_SIZE)
		openDoor = Doorway('left', true, self.nextRoom, nil, doorway.y) 
	elseif shiftX < 0 then --left room
		playerX = -VIRTUAL_WIDTH + (MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.player.width)
		openDoor = Doorway('right', true, self.nextRoom, nil, doorway.y) 
	elseif shiftY > 0 then --bottom room
		playerY = VIRTUAL_HEIGHT + (MAP_RENDER_OFFSET_Y + self.player.height / 2)
		openDoor = Doorway('top', true, self.nextRoom, doorway.x) 
	else -- top room
		playerY = -VIRTUAL_HEIGHT + MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.player.height
		openDoor = Doorway('bottom', true, self.nextRoom, doorway.x) 
	end

	table.insert(self.nextRoom.doorways, openDoor)

	-- for k, doorway in pairs(self.nextRoom.doorways) do
	-- 	doorway.open = true
	-- end

	self.nextRoom.adjacentOffsetX = shiftX
	self.nextRoom.adjacentOffsetY = shiftY

	Timer.tween(1, {
		[self] = {cameraX = shiftX, cameraY = shiftY},
		[self.player] = {x = playerX, y = playerY}
	}):finish(function() 
		self:finishShifting()

		if shiftX > 0 then
			self.player.x = playerX - VIRTUAL_WIDTH
			self.player.direction = 'right'
		elseif shiftX < 0 then
			self.player.x = MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.player.width
			self.player.direction = 'left'
		elseif shiftY < 0 then
			self.player.y = MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.player.height
			self.player.direction = 'up'
		else
			self.player.y = MAP_RENDER_OFFSET_Y + self.player.height / 2
			self.player.direction = 'down'
		end

		gSounds['door']:play()
	end)
end

function Dungeon:finishShifting()
	self.cameraX = 0
	self.cameraY = 0
	self.shifting = false

	self.currentRoom = self.nextRoom
	self.nextRoom = nil

	self.currentRoom.adjacentOffsetX = 0
	self.currentRoom.adjacentOffsetY = 0	
end

function Dungeon:update(dt)
	if not self.shifting then
		self.currentRoom:update(dt)
	else
		self.player.currentAnimation:update(dt)
	end
end

function Dungeon:render()

	if self.shifting then
		love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
	end

	self.currentRoom:render()

	if self.nextRoom then
		self.nextRoom:render()
	end
end