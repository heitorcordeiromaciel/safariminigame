# 003_MovementController.rb
# Handles Pokémon movement on the playing field

class MovementController
  attr_reader :pokemons

  def initialize(pokemons)
    @pokemons = pokemons
    # Assign a random initial direction to each Pokémon
    @pokemons.each do |poke|
      poke.direction = rand * 2 * Math::PI # Radians: 0..2π
    end
  end

  # Call this every frame
  def update
    @pokemons.each do |poke|
      move_pokemon(poke)
    end
  end

  # --- Movement Logic ---
  def move_pokemon(poke)
    speed_multiplier = SafariArcade::NATURE_SPEED_MULTIPLIERS[poke.nature] || 1.0
    move_x = poke.speed * Math.cos(poke.direction) * speed_multiplier
    move_y = poke.speed * Math.sin(poke.direction) * speed_multiplier

    poke.x += move_x
    poke.y += move_y

    bounce_if_edge(poke)
  end


  def bounce_if_edge(poke)
    bounced = false

    if poke.x < SafariArcade::FIELD_X_MIN
      poke.x = SafariArcade::FIELD_X_MIN
      poke.direction = Math::PI - poke.direction
      bounced = true
    elsif poke.x > SafariArcade::FIELD_X_MAX
      poke.x = SafariArcade::FIELD_X_MAX
      poke.direction = Math::PI - poke.direction
      bounced = true
    end

    if poke.y < SafariArcade::FIELD_Y_MIN
      poke.y = SafariArcade::FIELD_Y_MIN
      poke.direction = -poke.direction
      bounced = true
    elsif poke.y > SafariArcade::FIELD_Y_MAX
      poke.y = SafariArcade::FIELD_Y_MAX
      poke.direction = -poke.direction
      bounced = true
    end

    # Slight random variation in direction after bounce
    if bounced
      poke.direction += rand(-0.2..0.2)
    end
  end

  # Optional cleanup
  def dispose
    # Nothing to dispose; Pokémon sprites are handled by SpawnController
  end
end
