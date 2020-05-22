PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, dungeon)
	self.entity = player
	self.dungeon = dungeon

	self.entity.offsetY = 5
	self.entity.offsetX = 0
end

function PlayerWalkState:update(dt)
	if love.keyboard.isDown('left') then
		self.entity.direction = 'left'
		self.entity:changeAnimation('walk-left')
	elseif love.keyboard.isDown('right') then
		self.entity.direction = 'right'
		self.entity:changeAnimation('walk-right')
	elseif love.keyboard.isDown('up') then
		self.entity.direction = 'up'
		self.entity:changeAnimation('walk-up')
	elseif love.keyboard.isDown('down') then
		self.entity.direction = 'down'
		self.entity:changeAnimation('walk-down')
	else
		self.entity:changeState('idle')
	end

	if love.keyboard.wasPressed('space') then
		self.entity:changeState('swing-sword')
	end

	EntityWalkState.update(self, dt)

	--TO DO BUMPED
end