class GoegulbeoSprite < Joybox::Physics::PhysicsSprite
	def initialize(world, player)
		@world = world
	    @goegulbeo_body = @world.new_body(
	      position: [300, 500],
	      type: Body::Dynamic,
	      fixed_rotation: true
	    ) do
	      polygon_fixture(
	        box: [18 / 4, 60 / 4],
	        friction: 0.7,
	        density: 1.0
	      )
	    end
		file_name = 'goegulbeo_sprite.png'
		super file_name: file_name, body: @goegulbeo_body
		player.add_observer(self)
	end

	def update(player_position)
		p player_position
		jump
	end

	def jump
    #if alive? && on_ground?
		self.body.apply_force force:[-40, -40]
    #  @on_ground = false
		SimpleAudioEngine.sharedEngine.playEffect 'jump.wav'
	end
end