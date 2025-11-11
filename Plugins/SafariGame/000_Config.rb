# 000_Config.rb
# Safari Arcade Minigame Configuration File

module SafariArcade
  # --- General Settings ---
  TOTAL_SAFARI_BALLS = 30      # Starting number of Safari Balls
  TIMER_LENGTH = 60             # Seconds for the minigame
  FIELD_WIDTH = 320             # Width of the playing field in pixels
  FIELD_HEIGHT = 240            # Height of the playing field in pixels
  MAX_ON_SCREEN = 6             # Maximum Pokémon on the field at once

  # --- Pokémon Spawn Settings ---
  BIOMES = [:forest, :desert, :cave, :lake]

  POKEMON_DATA = [
    { species: :PIDGEY,    spawn_rate: 0.3, speed: 2, catch_rate: 0.8, biome: :forest },
    { species: :RATTATA,   spawn_rate: 0.25, speed: 3, catch_rate: 0.75, biome: :forest },
    { species: :PIKACHU,   spawn_rate: 0.15, speed: 4, catch_rate: 0.5, biome: :forest },
    { species: :DRAGONITE, spawn_rate: 0.05, speed: 6, catch_rate: 0.2, biome: :lake },
  ]
  NATURES = [
    :JOLLY, :TIMID, :QUIET, :ADAMANT, :MODEST, :CALM
  ]

  # Multipliers for movement speed by nature
  NATURE_SPEED_MULTIPLIERS = {
    JOLLY: 1.5,
    TIMID: 1.3,
    QUIET: 0.8,
    ADAMANT: 1.1,
    MODEST: 0.9,
    CALM: 0.7
  }

  # --- Ball Animation Settings ---
  BALL_WOBBLES = 3              # Number of times ball wobbles before catch check

  # --- Escape Settings ---
  # Escape checks happen at each wobble + final check after third wobble
  ESCAPE_STEPS = BALL_WOBBLES + 1

  # --- Field Boundaries ---
  # Pokémon and crosshair should stay within these
  FIELD_X_MIN = 0
  FIELD_Y_MIN = 0
  FIELD_X_MAX = FIELD_WIDTH
  FIELD_Y_MAX = FIELD_HEIGHT

  # --- Crosshair Settings ---
  CROSSHAIR_SPEED = 4            # Pixels per update for directional input

  # --- Miscellaneous ---
  FRAME_RATE = 60               # Game frames per second (used for timer and spawn intervals)
end
