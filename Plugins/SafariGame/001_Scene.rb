# 001_Scene.rb
# Main Safari Arcade Scene

class Scene_SafariArcade < Scene_Base
  def start
    super
    @current_biome = SafariArcade::BIOMES.sample
    # --- Initialize Controllers ---
    @spawn_controller      = SpawnController.new
    @spawn_controller.current_biome = @current_biome
    @movement_controller   = MovementController.new(@spawn_controller.pokemons)
    @crosshair_controller  = CrosshairController.new
    @ball_controller       = BallController.new(@spawn_controller.pokemons, @crosshair_controller)
    @timer_controller      = TimerController.new
    @hud_controller        = HUDController.new(@crosshair_controller, @ball_controller, @timer_controller)

    # --- Game State ---
    @game_over = false

    case @current_biome
    when :forest
        @background_bitmap = Bitmap.new("Graphics/Plugins/SafariGame/forest_bg")
    when :desert
        @background_bitmap = Bitmap.new("Graphics/Plugins/SafariGame/desert_bg")
    when :cave
        @background_bitmap = Bitmap.new("Graphics/Plugins/SafariGame/cave_bg")
    when :lake
        @background_bitmap = Bitmap.new("Graphics/Plugins/SafariGame/lake_bg")
    end
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

    # --- Check Game Over ---
    if @ball_controller.balls_left <= 0 || @timer_controller.time_left <= 0
      end_game
    end
  end

  def end_game
    @game_over = true
    # Optional: show results, fade out, return to map
    pbMessage("Safari Minigame Over! You caught #{@spawn_controller.caught_count} Pokémon!")
    pbFadeOutIn {
      SceneManager.return
    }
  end

  def terminate
    super
    # Dispose sprites and resources if needed
    @hud_controller.dispose
    @crosshair_controller.dispose
    @ball_controller.dispose
    @movement_controller.dispose
    @spawn_controller.dispose
  end
end
