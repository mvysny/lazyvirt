require 'io/console'

# Runs an event loop. Terminates when 'q' is pressed.
# Yields any pressed character to given block. Examples of characters:
# - `\e[B` for down arrow
# - `\e[A` for up arrow
def event_loop
  STDIN.echo = false
  STDIN.raw!

  loop do
    char = STDIN.getch
    break if char == 'q'

    if char == "\e"
      begin
        char << STDIN.read_nonblock(3)
      rescue StandardError
        nil
      end
      begin
        char << STDIN.read_nonblock(2)
      rescue StandardError
        nil
      end
    end
    yield char
  end
ensure
  STDIN.echo = true
  STDIN.cooked!
end
