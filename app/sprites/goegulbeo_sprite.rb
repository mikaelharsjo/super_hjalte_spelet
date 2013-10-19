class GoegulbeoSprite < Joybox::Physics::PhysicsSprite
	def initialize(world)
		@world = world
	    @goegulbeo_body = @world.new_body(
	      position: [500, 500],
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
	end
end