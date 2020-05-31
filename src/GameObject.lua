GameObject = Class{}

function GameObject:init(def, x, y)
	self.type = def.type

	self.texture = def.texture
	self.frame = def.frame or 1

	self.solid = def.solid

	self.defaultState = def.defaultState
	self.state = self.defaultState
	self.states = def.states

	self.x = x
	self.y = y
	self.width = def.width
	self.height = def.height

	self.onCollide = function() end
end

function GameObject:update(dt)

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
	love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame], self.x + adjacentOffsetX, self.y + adjacentOffsetY)

	--self:debug()
end

function GameObject:debug()
	love.graphics.setColor(1, 0, 1, 1)
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
	love.graphics.setColor(1, 1, 1, 1)
end