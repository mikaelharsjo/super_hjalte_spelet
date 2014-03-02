class Enemy < Joybox::Physics::PhysicsSprite
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