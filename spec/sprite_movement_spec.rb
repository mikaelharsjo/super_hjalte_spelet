require_relative '../app/lib/direction'
require_relative '../app/lib/direction_calculator'
require_relative '../app/lib/sprite_movement'
require_relative 'mocks'
require 'observer'

include Mocks

class Enemy
	attr_accessor :position, :body
	def initialize player
		@body = Body.new 0, 0
		player.add_observer(self)
	end

	include SpriteMovement
end

class MockPlayerSprite
	attr_accessor :position, :body
	include Observable

	def initialize
		@body = Body.new 1, 1
	end

	def moving
		changed
		notify_observers(self.body.position)
	end
end

describe Enemy do
	let(:player) { MockPlayerSprite.new }
	let(:enemy) { Enemy.new player }

	context 'playing the sprite role' do
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
		end

		it 'always moves towards where it thinks the player is' do
			# player starts north-east of enemy
			enemy.body.position.should eq CGPoint.new 0, 0
			player.moving
			# enemy should jump right towards player
			enemy.body.position.should eq CGPoint.new 1, 1

			# place player north-west of enemy
			player.body.position = CGPoint.new 0, 2
			player.moving
			# enemy should jump left towards player
			enemy.body.position.should eq CGPoint.new 0, 2

			player.body.position = CGPoint.new 999, 999
			player.moving
			# should jump right again
			enemy.body.position.should eq CGPoint.new 1, 3		
		end
	end
end