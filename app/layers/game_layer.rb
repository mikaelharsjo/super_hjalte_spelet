class GameLayer < Joybox::Core::Layer
  include Joybox::TMX

  attr_reader :player, :xOffset

  scene

  def on_enter
    SpriteFrameCache.frames.add file_name: "graphics/sprites.plist"
    @sprite_batch = SpriteBatch.new file_name: "graphics/sprites.png"
    self << @sprite_batch

    #@sprite_batch << Sprite.new(frame_name: 'boy.png', position: [Screen.half_width, Screen.half_height])
    
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
    @xOffset = 0
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
    #load_vampire_at [1850, 35]
    #load_vampire_at [1450, 35]
    #load_goegulbeo
    #load_ajaj_moster
  end

  def load_goegulbeo
    goegulbeo = GoegulbeoSprite.new @world, @player, [2450, 105]
    @tile_map.add_child goegulbeo, 15
    @enemies << goegulbeo
  end

  def load_ajaj_moster
    enemy = AjajMonsterSprite.new @world, @player, [450, 105]
    @tile_map.add_child enemy, 15
    @enemies << enemy
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
        set_viewpoint_center(@player.body.position)
      else
        game_over
      end
    end
  end

  def configure_controls
    on_touches_began do |touches, event|
      # p "touches.any_object.location.inspect: #{touches.any_object.location.inspect}"
      location = touches.any_object.location
      #p "player.bounding_box: #{@player.bounding_box.inspect}"
      # p "player.body.position: #{@player.body.position.inspect}"
      # p "player.body.fixtures.first.shape.inspect: #{@player.body.fixtures.first.shape.inspect}"
      location.x = location.x + @xOffset
      player_rect = CGRectInset(@player.bounding_box, -20, -20)
      @player.jump if CGRectContainsPoint player_rect, location
      @enemies.each do |enemy|
        enemy.hurt if CGRectContainsPoint enemy.bounding_box, location
      end
    end
  end

  def set_viewpoint_center(position)
    x = [position.x, Screen.width / 2].max
    y = [position.y, Screen.height / 2].max
    x = [x, (@tile_map.mapSize.width * @tile_map.tileSize.width) - Screen.half_width].min
    y = [y, (@tile_map.mapSize.height * @tile_map.tileSize.height) - Screen.half_height].min

    viewPoint = Screen.center - [x, y].to_point
    @xOffset += (viewPoint.x - @tile_map.position.x).abs
    @tile_map.position = viewPoint
  end

  def detect_collisions
    @world.when_collide @player do |collision_sprite, is_touching|
      @player.on_ground = true
      #p 'on_ground'
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