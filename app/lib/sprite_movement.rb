module SpriteMovement
	include Direction
	
	def jump_up
		p 'jumping up'
		body.position.y += 1
	end

	def jump_right
		p 'jumping right'
		body.position.x += 1
		body.position.y += 1
	end

	def jump_left
		p 'jumping left'
		body.position.x -= 1
		body.position.y += 1		
	end

	def move_right
	end

	def move_left
	end

	def jump
	end

	def update position
		direction = DirectionCalculator.direction body.position, position	
		p "enemy position: #{body.position.x}, #{body.position.x}"
		p "player position: #{position.x}, #{position.x}"
		p "direction: #{direction}"
		move_towards direction
	end

	def move_towards direction
		return jump_up if direction == NORTH
		return jump_right if direction == NORTH_EAST
		return jump_left if direction == NORTH_WEST
	end
end