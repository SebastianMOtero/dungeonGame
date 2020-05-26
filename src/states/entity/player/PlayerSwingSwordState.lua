PlayerSwingSwordState = Class{__includes = BaseState}

function PlayerSwingSwordState:init(player, dungeon)
	self.player = player
	self.dungeon = dungeon

	self.player.offsetY = 5
	self.player.offsetX = 8

	self.swordHitbox = self:hitboxValues(self.player.direction)

	self.player:changeAnimation('sword-' .. self.player.direction)
end

function PlayerSwingSwordState:enter(params)
	gSounds['sword']:stop()
	gSounds['sword']:play()

	self.player.currentAnimation:refresh()
end

function PlayerSwingSwordState:hitboxValues(direction)
	local hitboxX, hitboxY, hitboxWidth, hitboxHeight

	if direction == 'left' then
		hitboxWidth = 8
		hitboxHeight = 16
		hitboxX = self.player.x - hitboxWidth
		hitboxY = self.player.y + 2
	elseif direction == 'right' then
		hitboxWidth = 8
		hitboxHeight = 16
		hitboxX = self.player.x + self.player.width
		hitboxY = self.player.y + 2
	elseif direction == 'up' then
		hitboxWidth = 16
		hitboxHeight = 4
		hitboxX = self.player.x
		hitboxY = self.player.y - hitboxHeight
	else
		hitboxWidth = 16
		hitboxHeight = 4
		hitboxX = self.player.x
		hitboxY = self.player.y + self.player.height
	end

	return Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
end

function PlayerSwingSwordState:update(dt)

	--TO DO SWORDHITBOX  ATTACK

	if self.player.currentAnimation.timesPlayed > 0 then
		self.player.currentAnimation.timesPlayed = 0
		self.player:changeState('idle')
	end

	if love.keyboard.wasPressed('space') then
		self.entity:changeState('swing-sword')
	end
end

function PlayerSwingSwordState:render()
	local anim = self.player.currentAnimation
	
	love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

	--self:debug()
end

function PlayerSwingSwordState:debug()
	love.graphics.setColor(1, 0, 1, 1)
	love.graphics.rectangle('line', self.swordHitbox.x, self.swordHitbox.y, self.swordHitbox.width, self.swordHitbox.height)
	love.graphics.setColor(1, 1, 1, 1)
end