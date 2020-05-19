Dungeon = Class{}

function Dungeon:init(player)
	self.player = player

	self.rooms = {}

	self.currentRoom = Room(self.player)
end