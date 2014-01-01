class GameLayer < Joybox::Core::Layer
  include Joybox::TMX

  attr_reader :player

  scene

  def on_enter
    initialize_world
    load_background
    load_tile_map
    create_fixtures
    load_player
    load_enemies
    configure_controls
    detect_collisions
    # set_background_music
    game_loop
  end

  private

  def load_tile_map
    @tile_map = TileMap.new file_name: 'demo.tmx'
    self.add_child @tile_map, -1
    #self << @tile_map
  end

  def load_background
    @blue_sky = LayerColor.new color: "#b6dddc".to_color
    self << @blue_sky
  end

  def initialize_world
    @world = World.new(gravity: [0, -9.8])
  end

  def create_fixtures
    game_fixture = GameFixture.new @world, @tile_map
    game_fixture.create
  end

  def load_player
    @player = PlayerSprite.new @world
    @tile_map.add_child @player, 15
  end

  def load_enemies
    @enemies ||= Array.new
    # @enemies << load_spider
    #load_vampire_at [300, 35]
    #load_vampire_at [400, 35]
  end

  def load_vampire_at position
    vampire = VampireSprite.new @world, @player, position
    @tile_map.add_child vampire, 15
    @enemies << vampire
  end

  def game_loop
    schedule_update do |delta|
      @player.broadcastPositionToEnemies
      detect_enemy_collisions
      if @player.alive?
        @world.step delta: delta
        @player.move_forward
        set_viewpoint_center(@player.position)
      else
        game_over
      end
    end
  end

  def configure_controls
    on_touches_began do |touches, event|
      p "touches.any_object.location.inspect: #{touches.any_object.location.inspect}"
      location = touches.any_object.location
      p "@player.bounding_box: #{@player.bounding_box.inspect}"
      p "player: #{@player.body.position.inspect}"
      p "player.body.fixtures.length: #{@player.body.fixtures.length}"
      p "player.body.fixtures.first.friction: #{@player.body.fixtures.first.friction}"
      p "player.body.fixtures.first.restitution: #{@player.body.fixtures.first.restitution}"
      p "player.body.fixtures.first.density: #{@player.body.fixtures.first.density}"
      #p "player.body.fixtures.first.inspect: #{@player.body.fixtures.first.inspect}"
      #p "player.body.fixtures.first.shape.inspect: #{@player.body.fixtures.first.shape.inspect}"
      @player.jump if CGRectContainsPoint @player.bounding_box, location
    end
  end

  def set_viewpoint_center(position)
    x = [position.x, Screen.width / 2].max
    y = [position.y, Screen.height / 2].max
    x = [x, (@tile_map.mapSize.width * @tile_map.tileSize.width) - Screen.half_width].min
    y = [y, (@tile_map.mapSize.height * @tile_map.tileSize.height) - Screen.half_height].min

    viewPoint = Screen.center - [x, y].to_point
    @tile_map.position = viewPoint
  end

  def detect_collisions
    @world.when_collide @player do |collision_sprite, is_touching|
      @player.on_ground = true
      #@player.die if @hazard_tiles.include?(collision_sprite)
    end
  end

  def detect_enemy_collisions
    @enemies.each do |enemy|
      if CGRectIntersectsRect(enemy.bounding_box, @player.bounding_box)
        @player.die
      end
    end
  end

  def set_background_music
    SimpleAudioEngine.sharedEngine.playBackgroundMusic "background.mp3"
  end

  def game_over
    Joybox.director.stop_animation
    Joybox.director.replace_scene GameOverLayer.scene
  end

end