# 004_CrosshairController.rb
# Handles player input and crosshair movement

class CrosshairController
  attr_reader :x, :y

  def initialize
    # Start crosshair roughly at center of field
    @x = SafariArcade::FIELD_WIDTH / 2
    @y = SafariArcade::FIELD_HEIGHT / 2
  end

  # Call every frame
  def update
    handle_input
  end

  def handle_input
    # Adjust x and y based on arrow keys or WASD
    if Input.press?(Input::UP)
      @y -= SafariArcade::CROSSHAIR_SPEED
    elsif Input.press?(Input::DOWN)
      @y += SafariArcade::CROSSHAIR_SPEED
    end

    if Input.press?(Input::LEFT)
      @x -= SafariArcade::CROSSHAIR_SPEED
    elsif Input.press?(Input::RIGHT)
      @x += SafariArcade::CROSSHAIR_SPEED
    end

    # Keep crosshair within field boundaries
    @x = [[@x, SafariArcade::FIELD_X_MIN].max, SafariArcade::FIELD_X_MAX].min
    @y = [[@y, SafariArcade::FIELD_Y_MIN].max, SafariArcade::FIELD_Y_MAX].min
  end

  # Optional: dispose any sprites if crosshair has a visual
  def dispose
    # Implement sprite disposal if you add a crosshair graphic
  end
end
