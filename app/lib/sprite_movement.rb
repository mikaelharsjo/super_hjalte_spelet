module SpriteMovement
	#attr_accessor :sleep_count

	include Direction

	def jump_up
		# p 'jumping up'
		self.body.apply_force force:[0, 20]
		body.position.y += 1
	end

	def jump_right
		# p 'jumping right'
		self.body.apply_force force:[15, 15]
	end

	def jump_left
		self.body.apply_force force:[-15, 20]
		# p 'jumping left'
		body.position.x -= 1
		body.position.y += 1		
	end

	def move_right
		# p 'moving right'
		self.body.apply_force force:[15, 0]
	end

	def move_left
		# p 'moving left'
		self.body.apply_force force:[-15, 0]
	end

	def update position
		direction = DirectionCalculator.direction body.position, position	
		# p "enemy position: #{body.position.x}, #{body.position.y}"
		# p "player position: #{position.x}, #{position.y}"
		# p "direction: #{direction}"
		if @sleep_count == 0
			move_towards direction
			@sleep_count = 10
		else
			@sleep_count = @sleep_count - 1
		end
	end

	def move_towards direction
		return unless above_ground?
		return jump_up if direction == NORTH
		return jump_right if direction == NORTH_EAST
		return jump_left if direction == NORTH_WEST
		return move_left if direction == WEST
		return move_right if direction == EAST
	end

	# Todo: Need to check if colliding with tile below or something
	def above_ground?
		body.position.y > 0
	end
end