class VampireSprite < Enemy
	attr_accessor :sleep_count
	include SpriteMovement

	def initialize(world, player, initial_position)
		@facing_left = true
		@lifes = 2
		@world = world
	    @body = @world.new_body(
	      position: initial_position,
	      type: Body::Dynamic,
	      fixed_rotation: true
	    ) do
	      polygon_fixture(
	        box: [18 / 4, 60 / 4],
	        friction: 0.7,
	        density: 1.0
	      )
	    end

		file_name = 'vampire_sprite.png'
		super file_name: file_name, body: @body

		player.add_observer(self)

		@sleep_count = 10
	end
end