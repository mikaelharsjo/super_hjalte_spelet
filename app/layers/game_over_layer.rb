class GameOverLayer < Joybox::Core::Layer

  scene

  def on_enter
    load_background
    configure_controls
  end

  def load_background
    background_sprite = Sprite.new file_name: 'game_over.png', position: Screen.center
    self << background_sprite
  end

  def configure_controls
    on_touches_ended do |touches, event|
      Joybox.director.replace_scene GameLayer.scene
      Joybox.director.start_animation
    end
  end

end
