PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.player = Player{
		animations = ENTITY_DEFS['player'].animations,
		x = VIRTUAL_WIDTH / 2 - 8,
		y = VIRTUAL_HEIGHT / 2 - 11,

		width = 16,
		height = 22,

		health = 6
	}

	self.player.stateMachine = StateMachine {
		['idle'] = function() return PlayerIdleState(self.player) end
	}
	self.player:changeState('idle')
	
	self.room = Room(self.player)

end

function PlayState:update(dt)
	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function PlayState:render()
	love.graphics.push()
	--TO DO DELETE
	self.room:render()
	love.graphics.pop()

end