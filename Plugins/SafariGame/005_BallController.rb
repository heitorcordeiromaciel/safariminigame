# 005_BallController.rb
class BallController
  attr_reader :balls_left

  def initialize(pokemons, crosshair)
    @pokemons = pokemons
    @crosshair = crosshair
    @balls_left = SafariArcade::TOTAL_SAFARI_BALLS

    @active_ball = nil
    @wobble_sprite = nil
  end

  def update
    handle_throw_input
    update_active_ball if @active_ball
  end

  def handle_throw_input
    return if @active_ball
    return unless Input.trigger?(Input::C)

    target = pokemon_under_crosshair
    return unless target

    throw_ball(target)
  end

  def pokemon_under_crosshair
    @pokemons.find do |poke|
      (poke.x - 16..poke.x + 16).cover?(@crosshair.x) &&
      (poke.y - 16..poke.y + 16).cover?(@crosshair.y)
    end
  end

	def throw_ball(pokemon)
		@balls_left -= 1
		@active_ball = {
			pokemon: pokemon,
			state: :pokemon_inside,
			wobble_count: 0,
			wobble_index: 0,
			wobble_timer: 0,
			angle_target: 0
		}

		# Hide Pokémon sprite while inside ball
		pokemon.sprite.visible = false

		# Create Poké Ball sprite
		@wobble_sprite = Sprite.new
		@wobble_sprite.bitmap = Bitmap.new("Graphics/Plugins/SafariGame/pokeball.png") rescue Bitmap.new(16,16)
		@wobble_sprite.x = pokemon.x
		@wobble_sprite.y = pokemon.y
		@wobble_sprite.z = 20
		@wobble_sprite.angle = 0

		# Immediate escape check
		if escape_check(pokemon)
			pokemon.sprite.visible = true   # show Pokémon again if it escapes
			remove_active_ball
			return
		end

		# Wobble sequence
		@wobble_sequence = [-15, 15, 0]
		@wobble_index = 0
		@wobble_progress = 0.0
		@wobble_speed = 0.15
	end

	def update_active_ball
		return unless @wobble_sprite && @active_ball

		ball = @active_ball
		# Keep ball sprite on Pokémon in case it moves
		@wobble_sprite.x = ball[:pokemon].x
		@wobble_sprite.y = ball[:pokemon].y

		case ball[:state]
		when :pokemon_inside
			# Already did initial escape check
			ball[:state] = :wobble
			ball[:wobble_count] = 0
			@wobble_index = 0
			@wobble_progress = 0.0
			ball[:angle_target] = @wobble_sequence[@wobble_index]

		when :wobble
			# Smooth rotation
			current_angle = @wobble_sprite.angle
			target_angle = @wobble_sequence[@wobble_index]
			delta = (target_angle - current_angle) * @wobble_speed
			@wobble_sprite.angle += delta

			if (target_angle - current_angle).abs < 0.5
				@wobble_index += 1
				if @wobble_index >= @wobble_sequence.size
					@wobble_index = 0
					ball[:wobble_count] += 1

					# Escape check after each wobble
					if escape_check(ball[:pokemon])
						ball[:pokemon].sprite.visible = true  # show Pokémon again
						remove_active_ball
						return
					end
				end
			end

			# After all wobble cycles, catch Pokémon
			if ball[:wobble_count] >= SafariArcade::BALL_WOBBLES
				final_catch(ball[:pokemon])
				remove_active_ball
			end
		end
	end

  def escape_check(pokemon)
    rand > pokemon.catch_rate
  end

	def final_catch(pokemon)
		# Darken ball sprite
		darken_sprite(@wobble_sprite)

		if rand <= pokemon.catch_rate
			# Add to party
			pkmn = Pokemon.new(pokemon.species, 30)
			pkmn.nature = pokemon.nature
			pbAddPokemonSilent(pkmn)

			# Fully despawn Pokémon from minigame
			pokemon.sprite.dispose
			@pokemons.delete(pokemon)
		else
			# If it escapes after last wobble, show sprite again
			pokemon.sprite.visible = true
		end
	end

  def darken_sprite(sprite)
    sprite.tone.set(-50, -50, -50)
  end

	def remove_active_ball
		@wobble_sprite.dispose if @wobble_sprite
		@wobble_sprite = nil
		@active_ball = nil
	end

  def dispose
    @wobble_sprite.dispose if @wobble_sprite
  end
end
