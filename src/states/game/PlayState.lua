PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.player = Player{
		animations = ENTITY_DEFS['player'].animations,
		walkSpeed = ENTITY_DEFS['player'].walkSpeed,
		x = VIRTUAL_WIDTH / 2 - 8,
		y = VIRTUAL_HEIGHT / 2 - 11,

		width = 16,
		height = 22,

		health = 6,

		offsetY = 5
	}

	self.dungeon = Dungeon(self.player)
	--self.currentRoom = Room(self.player)

	self.player.stateMachine = StateMachine {
		['idle'] = function() return PlayerIdleState(self.player) end,
		['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
		['swing-sword'] = function() return PlayerSwingSwordState(self.player, self.dungeon) end
	}
	self.player:changeState('idle')
end

function PlayState:update(dt)
	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

	self.dungeon:update(dt)
end

function PlayState:render()
	love.graphics.push()
	--TO DO DELETE
	self.dungeon:render()
	love.graphics.pop()

	local healthLeft = self.player.health

	for i = 1, 3 do
		if healthLeft > 1 then
			heartFrame = 5
		elseif healthLeft == 1 then
			heartFrame = 3
		else
			heartFrame = 1
		end

		love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame], (i - 1) * (TILE_SIZE + 1), 2)

		healthLeft = healthLeft - 2

	end
end