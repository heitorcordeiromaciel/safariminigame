# 006_HUDController.rb
# Handles displaying Safari Balls, timer, and Pokémon caught

class HUDController
  def initialize(crosshair_controller, ball_controller, timer_controller, spawn_controller = nil)
    @crosshair = crosshair_controller
    @balls = ball_controller
    @timer = timer_controller
    @spawn = spawn_controller  # Optional: for caught count

    create_sprites
  end

  # --- Create HUD Sprites ---
  def create_sprites
    # Timer
    @timer_sprite = BitmapSprite.new(120, 32, viewport=nil)
    @timer_sprite.z = 100
    @timer_sprite.bitmap.clear

    # Balls
    @balls_sprite = BitmapSprite.new(120, 32, viewport=nil)
    @balls_sprite.z = 100
    @balls_sprite.bitmap.clear

    # Pokémon caught
    @caught_sprite = BitmapSprite.new(120, 32, viewport=nil)
    @caught_sprite.z = 100
    @caught_sprite.bitmap.clear
  end

  # Call every frame
  def update
    draw_timer
    draw_balls
    draw_caught
  end

  # --- Draw Timer ---
  def draw_timer
    @timer_sprite.bitmap.clear
    @timer_sprite.bitmap.draw_text(0, 0, 120, 32, "Time: #{@timer.time_left}", 1)
  end

  # --- Draw Balls ---
  def draw_balls
    @balls_sprite.bitmap.clear
    @balls_sprite.bitmap.draw_text(0, 0, 120, 32, "Balls: #{@balls.balls_left}", 1)
  end

  # --- Draw Pokémon Caught ---
  def draw_caught
    return unless @spawn
    @caught_sprite.bitmap.clear
    @caught_sprite.bitmap.draw_text(0, 0, 120, 32, "Caught: #{@spawn.caught_count}", 1)
  end

  # Optional: dispose sprites
  def dispose
    @timer_sprite.dispose if @timer_sprite
    @balls_sprite.dispose if @balls_sprite
    @caught_sprite.dispose if @caught_sprite
  end
end
