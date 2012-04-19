# Display inline list of plugin commands with short descriptions
class QuickHelpController < RallyController

  def initialize
    super()
  end

  def execute

      VIM::command("redraw")

      VIM::message("Quick Help: Rally plugin commands.  See ':help rally-commands' for details.")
      VIM::message(" ")
      display_row("search", "chart_iteration_burndown")
      display_row("update_task_todo", "chart_iteration_cumulative_flow")
      display_row("update_task_estimate", "")
      display_row("update_task_toggle_blocked", "quickhelp")
      display_row("", "info")
      display_row("choose_workspace", "")
# FIXME add back for next version      display_row("choose_iteration", "")
      VIM::message(" ")
 
      VIM::evaluate("input('Press any key to continue...')")

      VIM::command("redraw")
  end

  private

  # Helper to format the 2-column display and do correct padding.
  def display_row(left, right)

    col_size = 35
    keys = $conn.vars["keys"]
    descriptions = $conn.vars["descriptions"]

    left_text = (left.empty?) ? "" : "   \\" + keys[left].ljust(2, ' ') + "  - " + descriptions[left]
    right_text = (right.empty?) ? "" : "   \\" + keys[right].ljust(2, ' ') + "  - " + descriptions[right]
    VIM::message(left_text.ljust(col_size, ' ') + right_text.ljust(col_size, ' '))
  end

end

