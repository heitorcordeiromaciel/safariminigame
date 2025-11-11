# 007_TimerController.rb
# Handles the countdown timer for the Safari Arcade minigame

class TimerController
  attr_reader :time_left

  def initialize
    @time_left = SafariArcade::TIMER_LENGTH  # Total seconds
    @frame_counter = 0                        # Counts frames to decrement each second
  end

  # Call every frame
  def update
    return if @time_left <= 0

    @frame_counter += 1
    # Decrement 1 second every FRAME_RATE frames
    if @frame_counter >= SafariArcade::FRAME_RATE
      @frame_counter = 0
      @time_left -= 1
    end
  end

  # Optional: reset the timer
  def reset
    @time_left = SafariArcade::TIMER_LENGTH
    @frame_counter = 0
  end

  # Optional cleanup
  def dispose
    # Nothing to dispose
  end
end
