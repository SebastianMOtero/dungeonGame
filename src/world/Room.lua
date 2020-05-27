Room = Class{}

function Room:init(player, openDoor)
	self.width = MAP_WIDTH
	self.height = MAP_HEIGHT

	self.tiles = {}
	self:generateWallsAndFloors()

	self.entities = {}
	self:generateEntities()

	self.objects = {}
	self:generateObjects()

	local doorsDirection = {'top', 'right', 'bottom', 'left'}
	self.openDoor = openDoor
	self.doorways = {}

	for k, direction in pairs(doorsDirection) do
		if direction ~= self.openDoor and math.random(2) == 1 then
			table.insert(self.doorways, Doorway(direction, false, self))
		end
	end
	--Always at least two doors
	--TO DO
	if #self.doorways == 0 then
		table.insert(self.doorways, Doorway(self.openDoor == 'top' and 'left' or 'top', false, self))
	end

	self.player = player

	self.renderOffsetX = MAP_RENDER_OFFSET_X
	self.renderOffsetY = MAP_RENDER_OFFSET_Y

	self.adjacentOffsetX = 0
	self.adjacentOffsetY = 0
end

function Room:generateEntities()
	local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

	local cantMobs = math.random(10)

	for i = 1, cantMobs do
		local type = types[math.random(#types)]

		table.insert(self.entities, Entity {
			animations = ENTITY_DEFS[type].animations,
			walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

			x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
				VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
			y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
				VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
			
			width = 16,
			height = 16,

			health = 1
		})

		self.entities[i].stateMachine = StateMachine {
			['walk'] = function() return EntityWalkState(self.entities[i]) end,
			['idle'] = function() return EntityIdleState(self.entities[i]) end
		}

		self.entities[i]:changeState('walk')
	end
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
		math.random(MAP_RENDER_OFFSET_X + TILE_SIZE, VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
		math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE, 		VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
	)

	switch.onCollide = function()
		if switch.state == 'unpressed' then
			switch.state = 'pressed'

			for k, doorway in pairs(self.doorways) do
				doorway.open = true
			end

			gSounds['door']:play()
		end
	end
	table.insert(self.objects, switch)
end

function Room:update(dt)
	if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~=0 then return end
	
	self.player:update(dt)

	for i = #self.entities, 1, -1 do
		local entity = self.entities[i]

		if entity.health <= 0 then
			entity.dead = true
		elseif not entity.dead then
			--TO DO entity:processAI({room = self}, dt)
			entity:update(dt)
		end

		if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
			gSounds['hit-player']:play()
			self.player:damage(1)
			-- self.player:goInvulnerable(1.5)

			if self.player.health == 0 then
		-- 		gStateMachine:change('game-over')
			end
		end
	end
	
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
		doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
	end

	--render objects
	for k, object in pairs(self.objects) do
		object:render(self.adjacentOffsetX, self.adjacentOffsetY)
	end

	for k, entity in pairs(self.entities) do
		if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
	end

	love.graphics.stencil(function()
		
		--right
		love.graphics.rectangle('fill', 
		MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE), MAP_RENDER_OFFSET_Y + (TILE_SIZE * 2), 
		TILE_SIZE * 2 + 6, 
		TILE_SIZE * (MAP_HEIGHT - 4)
		)

		--left
		love.graphics.rectangle('fill', 
			-TILE_SIZE - 6, 
			MAP_RENDER_OFFSET_Y + (TILE_SIZE * 2), 
			TILE_SIZE * 2 + 6, 
			TILE_SIZE * (MAP_HEIGHT - 4)
		)

		--top
		love.graphics.rectangle('fill', 
			MAP_RENDER_OFFSET_X + (TILE_SIZE * 2), 
			-TILE_SIZE - 6, 
			TILE_SIZE * (MAP_WIDTH - 4),
			TILE_SIZE * 2 + 12
		)

		--bottom
		love.graphics.rectangle('fill', 
			MAP_RENDER_OFFSET_X + (TILE_SIZE * 2), 
			VIRTUAL_HEIGHT - TILE_SIZE - 6, 
			TILE_SIZE * (MAP_WIDTH - 4),
			TILE_SIZE * 2 + 12
		)
		
	end, 'replace', 1)

	love.graphics.setStencilTest('less', 1)

	if self.player then
		self.player:render()
	end

	love.graphics.setStencilTest()

	--self:debug()
end

function Room:debug()
	love.graphics.setColor(1, 0, 0, 1)

	--right
	love.graphics.rectangle('fill', 
		MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE), MAP_RENDER_OFFSET_Y + (TILE_SIZE * 2), 
		TILE_SIZE * 2 + 6, 
		TILE_SIZE * (MAP_HEIGHT - 4)
	)

	--left
	love.graphics.rectangle('fill', 
		-TILE_SIZE - 6, 
		MAP_RENDER_OFFSET_Y + (TILE_SIZE * 2), 
		TILE_SIZE * 2 + 6, 
		TILE_SIZE * (MAP_HEIGHT - 4)
	)

	--top
	love.graphics.rectangle('fill', 
		MAP_RENDER_OFFSET_X + (TILE_SIZE * 2), 
		-TILE_SIZE - 6, 
		TILE_SIZE * (MAP_WIDTH - 4),
		TILE_SIZE * 2 + 12
	)

	--bottom
	love.graphics.rectangle('fill', 
		MAP_RENDER_OFFSET_X + (TILE_SIZE * 2), 
		VIRTUAL_HEIGHT - TILE_SIZE - 6, 
		TILE_SIZE * (MAP_WIDTH - 4),
		TILE_SIZE * 2 + 12
	)

	love.graphics.setColor(1, 1, 1, 1)
end