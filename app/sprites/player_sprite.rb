class PlayerSprite < Joybox::Physics::PhysicsSprite
	attr_accessor :on_ground

	include Observable

	def initialize(world)
		@world = world
		@player_body = @world.new_body(
			position: [16*1, 16*9],
			type: Body::Dynamic,
			fixed_rotation: true
		) do
			polygon_fixture(
				box: [18 / 4, 60 / 4],
				friction: 0.7,
				density: 1.0
			)
		end
		super file_name: 'hero.png', body: @player_body
		@alive = true
		@on_ground = true
	end

	def alive?
		@alive && above_ground?
	end

	def on_ground?
		@on_ground
	end

	def move_forward
		if alive?
			self.body.apply_force force:[5, 0], as_impulse: true
		end
	end

	def jump
		if alive? && on_ground?
			self.body.apply_force force:[15, 50]
			@on_ground = false
			SimpleAudioEngine.sharedEngine.playEffect 'jump.wav'
			changed
			notify_observers(self.body.position)
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