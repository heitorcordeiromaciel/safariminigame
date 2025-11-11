# 005_BallController.rb
# Handles Poké Ball throwing, wobble animation, and catch logic

class BallController
  attr_reader :balls_left

  def initialize(pokemons, crosshair)
    @pokemons = pokemons                  # Reference to SpawnController's Pokémon list
    @crosshair = crosshair                # Reference to CrosshairController
    @balls_left = SafariArcade::TOTAL_SAFARI_BALLS
    @active_ball = nil                    # Track currently thrown ball
    @wobble_step = 0
    @wobble_timer = 0
  end

  # Call every frame
  def update
    handle_throw_input
    update_active_ball if @active_ball
  end

  # --- Handle Player Throw ---
  def handle_throw_input
    return if @active_ball
    return unless Input.trigger?(Input::C)  # Example: C button to throw

    target = pokemon_under_crosshair
    return unless target

    throw_ball(target)
  end

  # --- Find Pokémon under crosshair ---
  def pokemon_under_crosshair
    @pokemons.find do |poke|
      # Simple bounding box check; adjust size if needed
      (poke.x - 16..poke.x + 16).cover?(@crosshair.x) &&
      (poke.y - 16..poke.y + 16).cover?(@crosshair.y)
    end
  end

  # --- Start throw sequence ---
  def throw_ball(pokemon)
    @balls_left -= 1
    @active_ball = { pokemon: pokemon, wobble_step: 0 }
    @wobble_timer = 0
  end

  # --- Update ball wobble ---
  def update_active_ball
    @wobble_timer += 1
    # Each wobble step lasts ~10 frames (adjust as needed)
    if @wobble_timer >= 10
      @wobble_timer = 0
      @active_ball[:wobble_step] += 1
      # Escape check at each wobble
      if escape_check(@active_ball[:pokemon])
        remove_active_ball
        return
      end
    end

    # After final wobble, final catch check
    if @active_ball[:wobble_step] >= SafariArcade::BALL_WOBBLES
      final_catch(@active_ball[:pokemon])
      remove_active_ball
    end
  end

  # --- Escape Check ---
  def escape_check(pokemon)
    rand > pokemon.catch_rate
  end

  # --- Final Catch ---
  def final_catch(pokemon)
    if rand <= pokemon.catch_rate
      # Caught Pokémon
      pbAddPokemonSilent(pokemon.species)
      @pokemons.delete(pokemon)
    end
  end

  # --- Reset active ball ---
  def remove_active_ball
    @active_ball = nil
  end

  # Optional cleanup
  def dispose
    # Dispose ball sprites if you create visual graphics
  end
end
