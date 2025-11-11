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
    @timer_sprite = BitmapSprite.new(160, 32, viewport=nil)
    @timer_sprite.z = 100
    @timer_sprite.bitmap.clear

    # Balls
    @balls_sprite = BitmapSprite.new(160, 32, viewport=nil)
    @balls_sprite.z = 100
    @balls_sprite.bitmap.clear

    # Pokémon caught
    @caught_sprite = BitmapSprite.new(160, 32, viewport=nil)
    @caught_sprite.z = 100
    @caught_sprite.bitmap.clear

    # Optional: icons (assumes you have icon graphics)
    @ball_icon = load_icon("pokeball_icon") rescue nil
    @pokemon_icon = load_icon("pokemon_icon") rescue nil
    @timer_icon = load_icon("timer_icon") rescue nil
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
    color = @timer.time_left <= 10 ? Color.new(255, 50, 50) : Color.new(255, 255, 255)
    @timer_sprite.bitmap.font.color = color
    x_offset = @timer_icon ? 20 : 0
    @timer_sprite.bitmap.draw_text(x_offset, 0, 140, 32, "Time: #{@timer.time_left}", 1)
    @timer_sprite.bitmap.blt(0, 0, @timer_icon, @timer_icon.rect) if @timer_icon
  end

  # --- Draw Balls ---
  def draw_balls
    @balls_sprite.bitmap.clear
    @balls_sprite.bitmap.font.color = Color.new(255, 255, 255)
    x_offset = @ball_icon ? 20 : 0
    @balls_sprite.bitmap.draw_text(x_offset, 0, 140, 32, "Balls: #{@balls.balls_left}", 1)
    @balls_sprite.bitmap.blt(0, 0, @ball_icon, @ball_icon.rect) if @ball_icon
  end

  # --- Draw Pokémon Caught ---
  def draw_caught
    return unless @spawn
    @caught_sprite.bitmap.clear
    @caught_sprite.bitmap.font.color = Color.new(255, 255, 255)
    x_offset = @pokemon_icon ? 20 : 0
    @caught_sprite.bitmap.draw_text(x_offset, 0, 140, 32, "Caught: #{@spawn.caught_count}", 1)
    @caught_sprite.bitmap.blt(0, 0, @pokemon_icon, @pokemon_icon.rect) if @pokemon_icon
  end

  # Optional: dispose sprites
  def dispose
    [@timer_sprite, @balls_sprite, @caught_sprite].each do |s|
      s.dispose if s
    end
    @timer_sprite = @balls_sprite = @caught_sprite = nil
    @ball_icon = @pokemon_icon = @timer_icon = nil
  end

  private

  # Helper to load icon graphics
  def load_icon(filename)
    Bitmap.new("Graphics/Plugins/SafariGame/#{filename}.png")
  end
end
