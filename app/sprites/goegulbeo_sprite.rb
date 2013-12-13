class GoegulbeoSprite < Joybox::Physics::PhysicsSprite
	include SpriteMovement
	#include Direction
	def initialize(world, player)
		@world = world
	    @goegulbeo_body = @world.new_body(
	      position: [300, 16*9],
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
		# bounding_box.origin => x: 275.0, y: 121.75 hero.png
		# bounding_box.size => width: 50.0, height: 44.5 hero.png

		# bounding_box.origin => x: 175.0, y: 50.25 goegulbeo_sprite.png
		# bounding_box.size => width: 250.0, height: 187.5 goegulbeo_sprite.png
		p "bounding_box: #{bounding_box.origin.x}, #{bounding_box.origin.y}"
		p "bounding_box: #{bounding_box.size.width}, #{bounding_box.size.height}"
	end

	def jump
    #if alive? && on_ground?
		self.body.apply_force force:[-40, -40]
    #  @on_ground = false
		SimpleAudioEngine.sharedEngine.playEffect 'jump.wav'
	end
end