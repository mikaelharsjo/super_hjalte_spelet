require_relative '../app/lib/direction'
require_relative '../app/lib/direction_calculator'
require_relative 'mocks'
require 'observer'

include Mocks

module SpriteMovement
	def jump_up
		p 'jumping up'
		body.position.y += 1
	end

	def jump_right
		p 'jumping right'
		body.position.x += 1
		body.position.y += 1
	end

	def jump_left
		p 'jumping left'
		body.position.x -= 1
		body.position.y += 1		
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
	include Direction

	def update position
		@players_last_position = position
		direction = DirectionCalculator.direction body.position, position	
		p "enemy position: #{body.position.x}, #{body.position.x}"
		p "player position: #{position.x}, #{position.x}"
		p "direction: #{direction}"
		move_towards direction
	end

	def move_towards direction
		return jump_up if direction == NORTH
		return jump_right if direction == NORTH_EAST
		return jump_left if direction == NORTH_WEST
	end
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

			it 'can see you' do
				enemy.players_last_position.should be_nil
				player.moving
				enemy.players_last_position.should_not be_nil
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