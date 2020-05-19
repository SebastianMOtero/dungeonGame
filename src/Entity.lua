Entity = Class{}

function Entity:init(def)
	self.direction = 'down'

	self.x = def.x
	self.y = def.y
	self.width = def.width
	self.height = def.height

	self.health = def.health
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
	self.currentAnimation = self.animation[name]
end

function Entity:update(dt)
end

function Entity:render()
end
