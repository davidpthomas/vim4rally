# Progress bar in Vim
class ProgressBar

  def initialize(display, size)
    display = display
    size = size

    VIM::command("let b:rally_progress_bar = vim#widgets#progressbar#NewSimpleProgressBar(\"#{display}\", #{size})")
  end

  def increment
    VIM::command("call b:rally_progress_bar.incr()")
  end

  def close
    VIM::command("call b:rally_progress_bar.restore()")
  end

end

