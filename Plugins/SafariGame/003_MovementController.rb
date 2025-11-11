# 003_MovementController.rb
# Handles Pokémon movement on the playing field

class MovementController
  attr_reader :pokemons

  def initialize(pokemons)
    @pokemons = pokemons

    # Assign a random initial direction to each Pokémon
    @pokemons.each { |poke| poke.direction = rand * 2 * Math::PI }
  end

  # Call every frame
  def update
    @pokemons.each do |poke|
      # Ensure newly spawned Pokémon have a direction
      poke.direction ||= rand * 2 * Math::PI
      move_pokemon(poke)
    end
  end

  # --- Movement Logic ---
  def move_pokemon(poke)
    # Skip if Pokémon is hidden inside a Poké Ball
    return if poke.sprite.nil? || !poke.sprite.visible

    # Apply Nature-based speed multiplier
    speed_multiplier = SafariArcade::NATURE_SPEED_MULTIPLIERS[poke.nature] || 1.0
    move_x = poke.speed * Math.cos(poke.direction) * speed_multiplier
    move_y = poke.speed * Math.sin(poke.direction) * speed_multiplier

    poke.x += move_x
    poke.y += move_y

    bounce_if_edge(poke)
  end

  # Bounce off field edges and slightly randomize direction
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

    # Slight random variation after bounce to avoid repetitive movement
    poke.direction += rand(-0.2..0.2) if bounced
  end

  # Optional cleanup
  def dispose
    # Nothing to dispose; Pokémon sprites are handled by SpawnController
  end
end
