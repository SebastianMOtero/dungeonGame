Animation = Class{}

function Animation:init(def)
	self.frames = def.frames
	self.interval = def.interval
	self.texture = def.texture
	self.looping = def.looping or true

	self.currentFrame = 1

end

function Animation:update(dt)

end

function Animation:getCurrentFrame()
	return self.frames[self.currentFrame]
end