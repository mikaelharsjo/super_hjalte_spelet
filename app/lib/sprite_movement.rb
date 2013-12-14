module SpriteMovement
	include Direction

	def jump_up
		p 'jumping up'
		body.position.y += 1
	end

	def jump_right
		p 'jumping right'
		self.body.apply_force force:[30, 30]
		body.position.x += 1
		body.position.y += 1
	end

	def jump_left
		self.body.apply_force force:[-40, -40]
		p 'jumping left'
		body.position.x -= 1
		body.position.y += 1		
	end

	def move_right
		p 'moving right'
		self.body.apply_force force:[20, 20]
	end

	def move_left
		p 'moving left'
		self.body.apply_force force:[-20, -20]
	end

	def jump
	end

	def update position
		direction = DirectionCalculator.direction body.position, position	
		p "enemy position: #{body.position.x}, #{body.position.y}"
		p "player position: #{position.x}, #{position.y}"
		p "direction: #{direction}"
		move_towards direction
	end

	def move_towards direction
		return jump_up if direction == NORTH
		return jump_right if direction == NORTH_EAST
		return jump_left if direction == NORTH_WEST
		return move_left if direction == WEST
		return move_right if direction == EAST
	end
end