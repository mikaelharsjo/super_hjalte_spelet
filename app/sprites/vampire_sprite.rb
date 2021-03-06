class VampireSprite < Enemy
	include SpriteMovement

	def initialize(world, player, initial_position)
		super()
		@world = world
		@lifes = 2
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

		super frame_name: 'vampire_sprite.png', body: @body

		player.add_observer(self)
	end
end