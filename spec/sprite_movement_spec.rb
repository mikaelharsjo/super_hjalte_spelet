require_relative '../app/lib/direction'
require_relative '../app/lib/direction_calculator'
require_relative 'mocks'
require 'observer'

include Mocks

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
	attr_accessor :players_last_position, :position, :body
	def initialize player
		@body = Body.new 0, 0
		player.add_observer(self)
	end

	include SpriteMovement
	def update position
		@players_last_position = position
		jump_right
	end

	def jump_right
		@body.position.x = 1
		@body.position.y = 1
	end
end

class MockPlayerSprite
	attr_accessor :position, :body
	include Observable

	def initialize
		@body = Body.new 5, 5
	end

	def moving
		changed
		notify_observers(self.body.position)
	end
end

describe Enemy do
	let(:player) { MockPlayerSprite.new }
	let(:enemy) { Enemy.new player }

	context 'Playing the sprite role' do
		it 'moves' do
			enemy.should respond_to :jump_left
			enemy.should respond_to :jump_right
			enemy.should respond_to :jump
			enemy.should respond_to :move_left
			enemy.should respond_to :move_right
		end

		context 'observing the player position' do
			it 'listens to player position changes' do
				enemy.should respond_to :update
			end

			it 'can see you' do
				enemy.players_last_position.should be_nil
				player.moving
				enemy.players_last_position.should_not be_nil
			end
		end

		it 'should always move towards where it thinks the player is' do
			# player starts north-east of enemy
			enemy.body.position.should eq(CGPoint.new 0, 0)
			player.moving
			# enemy should jump right towards player
			enemy.body.position.should eq(CGPoint.new 1, 1)
		end
	end
end