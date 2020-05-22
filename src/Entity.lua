Entity = Class{}

function Entity:init(def)
	self.direction = 'down'

	self.animations = self:createAnimations(def.animations)
	self.walkSpeed = def.walkSpeed

	self.x = def.x
	self.y = def.y
	self.width = def.width
	self.height = def.height

	self.offsetX = def.offsetX or 0
	self.offsetY = def.offsetY or 0

	self.health = def.health
end

function Entity:createAnimations(animations)
	local animationsReturned = {}

	for k, animationDef in pairs(animations) do
		animationsReturned[k] = Animation {
			texture = animationDef.texture or 'entities',
			frames = animationDef.frames,
			interval = animationDef.interval
		}
	end

	return animationsReturned
end

function Entity:damage(dmg)
	self.health = self.health - dmg
end

function Entity:goInvulnerable(duration)
	self.invulnerable = true
	self.invulnerableDuration = duration
end

function Entity:changeState(name)
	self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
	self.currentAnimation = self.animations[name]
end

function Entity:update(dt)

	self.stateMachine:update(dt)

	if self.currentAnimation then
		self.currentAnimation:update(dt)
	end

end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
	self.stateMachine:render()
end
