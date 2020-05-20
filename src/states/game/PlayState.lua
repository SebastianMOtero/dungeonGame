PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.player = Player{

	}

	self.room = Room()
end

function PlayState:update(dt)
	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function PlayState:render()
	love.graphics.push()
	--TO DO DELETE
	self.room:render(self.player)
	love.graphics.pop()

end