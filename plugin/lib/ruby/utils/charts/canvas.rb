# Base class for managing a drawing canvas in vim
class Canvas

  attr_accessor :window, :buffer

  def initialize

    @window = VIM::Window.current   # current window
    @buffer = VIM::Buffer.current   # current buffer

    @window_width = @window.width + 1
    @window_height = @window.height
    @canvas_width = @window_width         # total visible drawing space
    @canvas_height = @window_height

    clear     # clear screen
    create    # create blank canvas

    # create a 'scratch' buffer that cannot be saved
    VIM::command("set nonumber")
    VIM::command("setlocal nobuflisted")
    VIM::command("setlocal noswapfile")
    VIM::command("setlocal buftype=nofile")
    VIM::command("setlocal bufhidden=unload")
    VIM::command("setlocal nolist")
    VIM::command("setlocal nonumber")
    VIM::command("setlocal showbreak=>>")
    VIM::command("setlocal nowrap")
  end

  private

  # creates a blank canvas (spaces) of entire window size
  def create
    for i in 1 .. (@canvas_height - 1) do
      @buffer.append(i, " " * (@canvas_width - 1))
    end
  end

  # removes all visible content from canvas buffer
  def clear
    VIM::command("%d")
  end

end
