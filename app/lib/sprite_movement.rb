module SpriteMovement
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
end