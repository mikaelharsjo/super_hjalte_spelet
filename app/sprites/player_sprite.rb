class PlayerSprite < Joybox::Physics::PhysicsSprite
	MAXIMUM_CONSTANT_VELOCITY = 7
	attr_accessor :on_ground

	include Observable

	def initialize(world)
		@player_body = world.new_body(position: [50, 35], 
			type: Body::Dynamic, 
			fixed_rotation: true
		) do
			polygon_fixture box: [18 / 4, 60 / 4], 
							friction: 0.9, 
							density: 1.0
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
			self.body.apply_force force:[8, 0]
		end
	end

	def jump
		if alive? && on_ground?
			self.body.apply_force force:[15, 40]
			@on_ground = false
			SimpleAudioEngine.sharedEngine.playEffect 'jump.wav'
			broadcastPositionToEnemies
		end
	end

	def die
		@alive = false
		self.run_action Blink.with times:50
		SimpleAudioEngine.sharedEngine.playEffect 'sounds/game_over.wav'
		SimpleAudioEngine.sharedEngine.pauseBackgroundMusic
	end

	def above_ground?
		@player_body.position.y > 0
	end
end