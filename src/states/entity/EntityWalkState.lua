EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, dungeon)
	self.entity = entity
	self.entity:changeAnimation('walk-down')

	self.dungeon = dungeon

	-- TO DO IA
end

function EntityWalkState:update(dt)
	if self.entity.direction == 'left' then
		self.entity.x = self.entity.x - self.entity.walkSpeed * dt

		if self.entity.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
		self.entity.x = MAP_RENDER_OFFSET_X + TILE_SIZE
		end
	elseif self.entity.direction == 'right' then
		self.entity.x = self.entity.x + self.entity.walkSpeed * dt

		if self.entity.x + self.entity.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
			self.entity.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.entity.width
		end
	elseif self.entity.direction == 'up' then
		self.entity.y = self.entity.y - self.entity.walkSpeed * dt

		if self.entity.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2 then
			self.entity.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2
		end
	elseif self.entity.direction == 'down' then
		self.entity.y = self.entity.y + self.entity.walkSpeed * dt

		if self.entity.y + self.entity.height >= VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE then
			self.entity.y = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - self.entity.height
		end
	end
end

--TO DO IA

function EntityWalkState:render()
	local anim = self.entity.currentAnimation

	love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end