class SpiderSprite < Joybox::Core::Sprite
	def initialize
		file_name = 'spider_sprite.png'
		start_position = [Screen.width, 30]
		super file_name: file_name, position: start_position
	end
end