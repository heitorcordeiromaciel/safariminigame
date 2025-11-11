# 004_CrosshairController.rb
# Handles player input and crosshair movement

class CrosshairController
  attr_reader :x, :y, :sprite

  def initialize
    # Start crosshair roughly at center of field
    @x = (SafariArcade::FIELD_X_MIN + SafariArcade::FIELD_X_MAX) / 2
    @y = (SafariArcade::FIELD_Y_MIN + SafariArcade::FIELD_Y_MAX) / 2

    # Create crosshair sprite
    @sprite = Sprite.new
    begin
      @sprite.bitmap = Bitmap.new("Graphics/Plugins/SafariGame/crosshair.png")
    rescue
      @sprite.bitmap = Bitmap.new(16,16) # fallback
    end
    @sprite.z = 30
    update_sprite_position
  end

  # Call every frame
  def update
    handle_input
    update_sprite_position
  end

  def handle_input
    # Adjust x and y based on arrow keys
    @y -= SafariArcade::CROSSHAIR_SPEED if Input.press?(Input::UP)
    @y += SafariArcade::CROSSHAIR_SPEED if Input.press?(Input::DOWN)
    @x -= SafariArcade::CROSSHAIR_SPEED if Input.press?(Input::LEFT)
    @x += SafariArcade::CROSSHAIR_SPEED if Input.press?(Input::RIGHT)

    # Keep crosshair within field boundaries
    @x = [[@x, SafariArcade::FIELD_X_MIN].max, SafariArcade::FIELD_X_MAX].min
    @y = [[@y, SafariArcade::FIELD_Y_MIN].max, SafariArcade::FIELD_Y_MAX].min
  end

  def update_sprite_position
    @sprite.x = @x
    @sprite.y = @y
  end

  # Dispose the crosshair sprite
  def dispose
    @sprite.dispose if @sprite
    @sprite = nil
  end
end
