class DashboardDisplayWindow < ManagedDisplayWindow

  def initialize(name, title)
    super("dashboard", name, title)
  end

  def display(results_formatter)

    # create a 'scratch' buffer that cannot be saved
    VIM::command("setlocal nobuflisted")
    VIM::command("setlocal noswapfile")
    VIM::command("setlocal buftype=nofile")
    VIM::command("setlocal bufhidden=unload")
    VIM::command("setlocal nolist")
    VIM::command("setlocal nonumber")
    VIM::command("setlocal showbreak=>>")
    VIM::command("setlocal nowrap")

    VIM::command("if has('syntax') | setlocal syntax=rally | endif")

    # Show splash screen in middle (vert) of window; calc 1/2 way point
    height = VIM::Window.current.height
    width = VIM::Window.current.width

    cnt = 0
    for i in 0..((height/2) - 1) do
      VIM::Buffer.current.append(i, "")
      cnt = cnt + 1
    end
    msg = "[  Loading Rally Data  ]"
    msg_display = " " * ((width / 2 ) - (msg.length / 2)) + msg
    VIM::Buffer.current.append(cnt, msg_display)

    # TODO: display random tooltip?

    # load content from rally
    content = results_formatter.content

    # delete splash screen
    VIM::command("%d")

    # fill buffer with content
    line_cnt = 0
    content.each_line do |line|
      VIM::Buffer.current.append(line_cnt, line.chomp!)
      line_cnt += 1
    end

    # set cursor upper left
    VIM::Window.current.cursor = [0,0]

    # show line under cursor to improve visualization
    VIM::command("setlocal cursorline")

  end
end
