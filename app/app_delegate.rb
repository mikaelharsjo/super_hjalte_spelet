class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @director = Joybox::Configuration.setup do
      director display_stats: false
      debug physics: [:aabb]         
    end

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@director)
    @navigation_controller.navigationBarHidden = true

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.setRootViewController(@navigation_controller)
    @window.makeKeyAndVisible

    # preload sounds effects
    SimpleAudioEngine.sharedEngine.preloadEffect('background.mp3')
    SimpleAudioEngine.sharedEngine.preloadEffect('jump.wav')
    SimpleAudioEngine.sharedEngine.preloadEffect('hurt.wav')

    # push the game scene onto the director
    @game_scene = GameLayer.scene
    @director << @game_scene

    true
  end

  def player
    @game_scene.children.getNSArray[0].player
  end

  def applicationWillResignActive(app)
    @director.pause if @navigation_controller.visibleViewController == @director
  end

  def applicationDidBecomeActive(app)
    @director.resume if @navigation_controller.visibleViewController == @director
  end

  def applicationDidEnterBackground(app)
    @director.stop_animation if @navigation_controller.visibleViewController == @director
  end

  def applicationWillEnterForeground(app)
    @director.start_animation if @navigation_controller.visibleViewController == @director
  end

  def applicationWillTerminate(app)
    @director.end
  end

  def applicationDidReceiveMemoryWarning(app)
    @director.purge_cached_data
  end

  def applicationSignificantTimeChange(app)
    @director.set_next_delta_time_zero true
  end
end