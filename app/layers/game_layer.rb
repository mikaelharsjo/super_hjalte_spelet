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
    self << @tile_map
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
    @tile_map.add_child @player, 25
  end

  def load_enemies
    @enemies ||= Array.new
    @enemies << load_spider
    load_goegulbeo
  end

  def load_goegulbeo
    goegulbeo = GoegulbeoSprite.new @world
    @tile_map.add_child goegulbeo, 15
  end

  def load_spider
    spider = SpiderSprite.new
    @tile_map.add_child spider, 15
    end_position = [0, 30]
    spider.run_action Move.to position: end_position, duration: 5.0
    spider
  end

  def game_loop
    schedule_update do |delta|
      detect_enemy_collisions
      if @player.alive?
        @world.step delta: delta
        @player.move_forward if @moving
        set_viewpoint_center(@player.position)
      else
        game_over
      end
    end
  end

  def configure_controls
    on_touches_began do |touches, event|
      touches.each do |touch|
        #location = touch.locationInView(touch.view)
        #location.x > (Screen.width / 2) ? (@moving = true) : @player.jump
        player.jump
      end
    end

    on_touches_ended do |touches, event|
      touches.each do |touch|
        @moving = false
      end
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