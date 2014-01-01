class PlayerSprite < Joybox::Physics::PhysicsSprite
	MAXIMUM_CONSTANT_VELOCITY = 8
	attr_accessor :on_ground#

	include Observable

	def initialize(world)
		polygon_shape = PolygonShape.new box: [16, 16]
		@player_body = world.new_body position: [16*1, 35], type: Body::Dynamic, fixed_rotation: true do
			polygon_fixture shape: polygon_shape,
							friction: 1, 
							density: 3, 
							restitution: 2
		end

		super file_name: 'hero.png', body: @player_body
		@alive = true
		@on_ground = true
	end

	def broadcastPositionToEnemies
		changed
		notify_observers(self.body.position)
	end

	def alive?
		@alive && above_ground?
	end

	def on_ground?
		@on_ground
	end

	def move_forward
		if alive? and self.body.linear_velocity.x < MAXIMUM_CONSTANT_VELOCITY
			#self.body.apply_force force:[2, 0], as_impulse: true
		end
	end

	def jump
		if alive? && on_ground?
			self.body.apply_force force:[50, 50]
			@on_ground = false
			SimpleAudioEngine.sharedEngine.playEffect 'jump.wav'
			broadcastPositionToEnemies
		end
	end

	def die
		@alive = false
		self.run_action Blink.with times:50
		SimpleAudioEngine.sharedEngine.playEffect 'hurt.wav'
		SimpleAudioEngine.sharedEngine.pauseBackgroundMusic
	end

	def above_ground?
		@player_body.position.y > 0
	end
end