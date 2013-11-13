# Simulates a CGPoint
class CGPoint
	attr_reader :x, :y

	def initialize(x, y)
		@x = x
		@y = y
	end
end


require_relative '../app/lib/direction_calculator'
require_relative '../app/lib/direction'

include Direction

describe DirectionCalculator do
	it 'stands still if on target' do
		direction = get_direction 1, 1, 1, 1
		direction.should eq(STILL)
	end

	it 'north' do
		direction = get_direction 1, 0, 1, 1
		direction.should eq(NORTH)
	end

	it 'north east' do
		get_direction(0, 0, 1, 1).should eq(NORTH_EAST)		
	end

	it 'north west' do
		get_direction(1, 0, 0, 1).should eq(NORTH_WEST)
	end

	it 'south' do
		get_direction(0, 1, 0, 0).should eq(SOUTH)
	end
end

def get_direction(x1, y1, x2, y2)
	first = CGPoint.new x1, y1
	second = CGPoint.new x2, y2

	DirectionCalculator.direction first, second
end