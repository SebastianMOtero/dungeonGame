PlayerSwingSwordState = Class{__includes = BaseState}

function PlayerSwingSwordState:init(player, dungeon)
	self.player = player
	self.dungeon = dungeon

	self.player.offsetY = 5
	self.player.offsetX = 8

	local direction = self.player.direction

	self.player:changeAnimation('sword-' .. self.player.direction)
end

function PlayerSwingSwordState:enter(params)
	gSounds['sword']:stop()
	gSounds['sword']:play()

	self.player.currentAnimation:refresh()
end

function PlayerSwingSwordState:update(dt)
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

end
