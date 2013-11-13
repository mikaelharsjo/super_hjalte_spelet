require_relative '../app/lib/direction_calculator'

module SpriteMovement
	def jump_up
	end

	def jump_right
	end

	def jump_left
	end

	def move_right
	end

	def move_left
	end

	def jump
	end
end

class Enemy
	include SpriteMovement
end

class MockPlayerSprite
	attr_accessor :position
	# include Observable
end

describe Enemy do

	before do
		@enemy = Enemy.new
	end

	context 'Playing the sprite role' do
		before do
			@player = MockPlayerSprite.new
		end

		it 'moves' do
			@enemy.should respond_to :jump_left
			@enemy.should respond_to :jump_right
			@enemy.should respond_to :jump
			@enemy.should respond_to :move_left
			@enemy.should respond_to :move_right
		end

		xit 'listens to player position changes' do
			@enemy.should respond_to :update


		end
	end
end