require_relative '../app/lib/direction'
require_relative '../app/lib/direction_calculator'
require_relative 'mocks'

include Mocks
include Direction

describe DirectionCalculator do
	describe '#direction' do
		it 'stands still if on target' do
			direction = get_direction 1, 1, 1, 1
			direction.should eq(STILL)
		end

		it 'goes north' do
			direction = get_direction 1, 0, 1, 1
			direction.should eq(NORTH)
		end

		it 'goes north east' do
			get_direction(0, 0, 1, 1).should eq(NORTH_EAST)		
		end

		it 'goes north west' do
			get_direction(1, 0, 0, 1).should eq(NORTH_WEST)
		end

		it 'goes south' do
			get_direction(0, 1, 0, 0).should eq(SOUTH)
		end

		it 'goes west' do
			get_direction(1, 0, 0, 0).should eq WEST
		end

		it 'goes east' do
			get_direction(0, 0, 1, 0).should eq EAST
		end

		context 'when close still find it (fuzzy)' do
			it 'goes east' do
				get_direction(0.4, 0.2, 1.1, 0.9).should eq EAST
			end			
		end
	end
end

def get_direction(x1, y1, x2, y2)
	first = CGPoint.new x1, y1
	second = CGPoint.new x2, y2

	DirectionCalculator.direction first, second
end