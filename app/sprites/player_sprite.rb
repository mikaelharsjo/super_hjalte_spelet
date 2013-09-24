class PlayerSprite < Joybox::Physics::PhysicsSprite

  def initialize(world)
    @world = world
    @player_body = @world.new_body(
      position: [16*1, 16*9],
      type: Body::Dynamic,
      fixed_rotation: true
    ) do
      polygon_fixture(
        box: [18 / 4, 60 / 4],
        friction: 0.7,
        density: 1.0
      )
    end
    super file_name: 'hero.png', body: @player_body
    @alive = true
  end

  def alive?
    @alive && above_ground?
  end

  def move_forward
    if alive?
      self.body.apply_force force:[5, 0], as_impulse: true
    end
  end

  def jump
    if alive? && on_solid_ground?
      self.body.apply_force force:[10, 40]
      #jump_by_action = Jump.by position: [20, 30]
      #run_action jump_by_action
      SimpleAudioEngine.sharedEngine.playEffect 'jump.wav'
    end
  end

  def die
    @alive = false
    self.run_action Blink.with times:50
    SimpleAudioEngine.sharedEngine.playEffect 'hurt.wav'
    SimpleAudioEngine.sharedEngine.pauseBackgroundMusic
  end

  def on_solid_ground?
    #p @player_body.position.y
    #p @worl.methods
    #@player_body.position.y < 36
    true
  end

  def above_ground?
    @player_body.position.y > 0
  end

end