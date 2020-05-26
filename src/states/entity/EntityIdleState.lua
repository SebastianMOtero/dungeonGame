EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
	self.entity = entity
	self.entity:changeAnimation('idle-' .. self.entity.direction)

	--TO DO IA
end

--TO DO IA

function EntityIdleState:render()
	local anim = self.entity.currentAnimation

	love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))

	--self:debug()
end

function EntityIdleState:debug()
	love.graphics.setColor(1, 0, 1, 1)
    love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    love.graphics.setColor(1, 1, 1, 1)
end