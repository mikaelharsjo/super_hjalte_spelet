class Enemy < Joybox::Physics::PhysicsSprite
	def hurt
		@lifes -= 1
		if @lifes == 0
			@world.destroy_body @body
			removeFromParentAndCleanup true
		end
	end

	def die
		@alive = false
		self.run_action Blink.with times:50
		SimpleAudioEngine.sharedEngine.playEffect 'hurt.wav'
		SimpleAudioEngine.sharedEngine.pauseBackgroundMusic
		changed
		notify_observers(self.body.position)
	end
end