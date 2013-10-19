class GameFixture
  def initialize world, tile_map
    @world = world
    @tile_map = tile_map
  end

  def create
    create_ground_fixtures
    #create_walls_fixtures
    #create_hazards_fixtures
  end

  private

  def create_ground_fixtures
    @walls = @tile_map.tile_layers['Ground']
    return if @walls.nil?
    size = @walls.layerSize

    (0..size.height - 1).each do |y|
      (0..size.width - 1).each do |x|
        tile = @walls.tileAt([x, y])
        create_rectangular_fixture(@walls, x, y) if tile
      end
    end
  end

  def create_rectangular_fixture(layer, x, y)
    tw = layer.tileset.tileSize.width / 4
    th = layer.tileset.tileSize.height / 4

    p = layer.positionAt [x, y]
    x = p.x + tw + 4
    y = p.y + th + 4

    # create the body, define the shape and create the fixture
    body = @world.new_body(
      position: [x, y],
      type: Body::Static) do
        polygon_fixture box: [tw, th],
                        density: 1.0,
                        friction: 0.3,
                        restitution: 0.0
    end
  end
end