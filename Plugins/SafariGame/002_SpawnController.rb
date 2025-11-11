# 002_SpawnController.rb
# Handles gradual Pokémon spawn and tracking

class SpawnController
  attr_reader :pokemons, :caught_count
	attr_accessor :current_biome

  def initialize
    @pokemons = []        # List of active Pokémon sprites on screen
    @caught_count = 0
    @frame_counter = 0    # Used to spawn Pokémon every second

    @current_biome = nil
  end

  # Call this every frame
  def update
    spawn_timer
  end

  # --- Spawn Logic ---
  def spawn_timer
    @frame_counter += 1
    if @frame_counter >= SafariArcade::FRAME_RATE
      @frame_counter = 0
      attempt_spawn
    end
  end

  def attempt_spawn
    return if @pokemons.size >= SafariArcade::MAX_ON_SCREEN
    return if @current_biome.nil?  # cannot spawn without a biome

    # Only spawn Pokémon that belong to the current biome
    SafariArcade::POKEMON_DATA.each do |data|
      next if data[:biome] != @current_biome
      next if @pokemons.size >= SafariArcade::MAX_ON_SCREEN
      spawn_pokemon(data) if rand < data[:spawn_rate]
    end
  end

	def spawn_pokemon(data)
		pokemon_sprite = PokemonSprite.new(data[:species])
		pokemon_sprite.speed = data[:speed]
		pokemon_sprite.catch_rate = data[:catch_rate]
		pokemon_sprite.x = rand(SafariArcade::FIELD_X_MIN..SafariArcade::FIELD_X_MAX)
		pokemon_sprite.y = rand(SafariArcade::FIELD_Y_MIN..SafariArcade::FIELD_Y_MAX)

		# Assign random Nature
		pokemon_sprite.nature = SafariArcade::NATURES.sample

		# Load party icon instead of front battle sprite
		# Assuming you have Essentials method: pbGetPokemonIconBitmap(species)
		pokemon_sprite.sprite = Sprite.new
		pokemon_sprite.sprite.bitmap = pbGetPokemonIconBitmap(data[:species])
		pokemon_sprite.sprite.x = pokemon_sprite.x
		pokemon_sprite.sprite.y = pokemon_sprite.y
		pokemon_sprite.sprite.z = 10

		@pokemons << pokemon_sprite
	end


  # Call this when a Pokémon is caught
  def pokemon_caught(pokemon)
    @pokemons.delete(pokemon)
    @caught_count += 1
  end

  # Optional cleanup
  def dispose
    @pokemons.each { |p| p.sprite.dispose if p.sprite }
		@pokemons.clear
  end
end
