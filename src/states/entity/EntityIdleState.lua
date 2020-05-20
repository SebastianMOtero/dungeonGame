EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
	self.entity = entity
	self.entity:changeAnimation('idle-' .. self.entity.direction)
end

function EntityIdleState:render()
	local anim = self.entity.currentAnimation

	love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
end