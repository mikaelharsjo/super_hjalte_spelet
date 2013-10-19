require 'rspec'
require_relative '../app/fixtures/game_fixture'

class MockWorld
end

class MockTileMap
end

describe GameFixture do
	it 'exists' do
		GameFixture.should_not be_nil
	end

	it 'has a create method' do
		mock_world = MockWorld.new
		mock_tile_map = MockTileMap.new

		game_fixture = GameFixture.new mock_world, mock_tile_map
		game_fixture.should respond_to(:create)
	end
end