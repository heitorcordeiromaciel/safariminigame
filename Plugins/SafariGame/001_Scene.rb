# 001_Scene.rb
# Main Safari Arcade Scene

class Scene_SafariArcade < Scene_Base
  def start
    super

    # --- Initialize Game State ---
    @game_over = false
    @exit_prompt_visible = false
    @current_biome = SafariArcade::BIOMES.sample

    # --- Initialize Controllers ---
    @spawn_controller      = SpawnController.new
    @spawn_controller.current_biome = @current_biome
    @movement_controller   = MovementController.new(@spawn_controller.pokemons)
    @crosshair_controller  = CrosshairController.new
    @ball_controller       = BallController.new(@spawn_controller.pokemons, @crosshair_controller)
    @timer_controller      = TimerController.new
    @hud_controller        = HUDController.new(@crosshair_controller, @ball_controller, @timer_controller, @spawn_controller)

    # --- Load Background ---
    bg_path = case @current_biome
              when :forest then "Graphics/Plugins/SafariGame/forest_bg"
              when :desert then "Graphics/Plugins/SafariGame/desert_bg"
              when :cave   then "Graphics/Plugins/SafariGame/cave_bg"
              when :lake   then "Graphics/Plugins/SafariGame/lake_bg"
              end
    @background_bitmap = Bitmap.new(bg_path)
    @background_sprite = Sprite.new
    @background_sprite.bitmap = @background_bitmap
    @background_sprite.z = 0
  end

  def update
    super
    return if @game_over

    # --- Update Controllers ---
    @spawn_controller.update
    @movement_controller.update
    @crosshair_controller.update
    @ball_controller.update
    @timer_controller.update
    @hud_controller.update

    # --- Check Exit Input ---
    handle_exit_input

    # --- Check Game Over ---
    if @ball_controller.balls_left <= 0 || @timer_controller.time_left <= 0
      end_game
    end
  end

  def handle_exit_input
    return if @exit_prompt_visible
    return unless Input.trigger?(Input::X)

    @exit_prompt_visible = true

    # Blocking prompt (minigame pauses while message shows)
    choice = pbMessage(_INTL("Do you want to leave the Safari minigame?"), [_INTL("Yes"), _INTL("No")])

    if choice == 0 # Yes
      end_game
    else           # No
      @exit_prompt_visible = false
    end
  end

  def end_game
    return if @game_over
    @game_over = true

    # Show result
    pbMessage(_INTL("Safari Minigame Over! You caught {1} Pokémon!", @spawn_controller.caught_count))

    # Fade out and return to map
    pbFadeOutIn { SceneManager.return }

    # Dispose resources
    terminate
  end

  def terminate
    super

    # Dispose all sprites and controllers
    @hud_controller.dispose if @hud_controller
    @crosshair_controller.dispose if @crosshair_controller
    @ball_controller.dispose if @ball_controller
    @movement_controller.dispose if @movement_controller
    @spawn_controller.dispose if @spawn_controller

    @background_sprite.dispose if @background_sprite
    @background_bitmap.dispose if @background_bitmap
  end
end
