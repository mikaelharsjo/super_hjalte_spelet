class GoegulbeoSprite < Enemy
	include SpriteMovement

	def initialize(world, player, initial_position)
		super()
		@world = world
		@lifes = 3
	    @goegulbeo_body = @world.new_body(
	      position: initial_position,
	      type: Body::Dynamic,
	      fixed_rotation: true
	    ) do
	      polygon_fixture(
	        box: [80, 80],
	        friction: 0.7,
	        density: 1.0
	      )
	    end

		super frame_name: 'goegulbeo_sprite.png', body: @goegulbeo_body

		player.add_observer(self)
	end

	def hurt
		setDisplayFrame SpriteFrameCache.frames['goegulbeo_sprite_.png']
		#setDisplayFrame SpriteFrameCache.frames['goegulbeo_sprite.png']
		super
	end
end