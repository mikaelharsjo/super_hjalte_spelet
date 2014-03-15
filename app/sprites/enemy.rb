class Enemy < Joybox::Physics::PhysicsSprite
	attr_accessor :sleep_count
	# defaults
	def initialize
		@lifes = 1
		@facing_left = true
		@sleep_count = 10
	end

	def hurt
		SimpleAudioEngine.sharedEngine.playEffect 'sounds/grunt.wav'
		@lifes -= 1
		if @lifes == 0
			@world.destroy_body @body
			die
			removeFromParentAndCleanup true
		end
	end

	def die
		@alive = false
		self.run_action Blink.with times:50
		#SimpleAudioEngine.sharedEngine.playEffect 'sounds/grunt.wav'
		#SimpleAudioEngine.sharedEngine.pauseBackgroundMusic
	end
end