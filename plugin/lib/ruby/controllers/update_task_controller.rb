# BASE CLASS ONLY
class UpdateTaskController < RallyController

  def initialize(field_label, field_method)
    # define before super as that invokes execute automatically
    @field_label = field_label
    @field_method = field_method
    super()
  end

  def execute

    prefix_task = $conn.workspace.prefix_task
   
    # look in buffer for currently loaded task
    if VIM::evaluate("exists(\"b:rally_vars['formatted_id']\")") == 1
      search_context = VIM::evaluate("b:rally_vars['formatted_id']")
    # look on current line for task ID
    else
      search_context = VIM::evaluate("getline('.')")
    end

    # extract formatted id from full string e.g. "foo S123 bar" -> "S123"
    if (match = search_context.match(/(#{prefix_task})(\d+)/))   # /(S|DE|TA)\d+/
      task_id = match[2]
    else
      task_id = VIM::evaluate("input('Rally Task ID: ')")
      task_id.gsub!(/#{prefix_task}/, '') # strip prefix if given
    end

    begin
      task = Task.find_by_id(task_id)
    rescue RallyObjectNotFound => e
      VIM::message("Rally Task ID '#{task_id}' does not exist.")
      return
    end

    task_unit_name = $conn.workspace.task_unit_name
    task_formatted_id = task.formatted_i_d
    task_display_name = (task.name.size > 40) ? task.name[0..40] + "..." : task.name
    blocked_display = (task.blocked?) ? "[BLOCKED] " : nil
    task_display = "#{task_formatted_id} - #{task_display_name} #{blocked_display}[Est: #{task.estimate} #{task_unit_name}] [To do: #{task.to_do} #{task_unit_name}] [Owner: #{task.owner}]"

    # prompt user
    if @field_method == :blocked
      display = (task.blocked?) ? "Unblock" : "Block"
      input = VIM::evaluate("input('#{task_display}\n#{display} task? (Y/n)')")
      if input !~ /[yY]/ && !input.empty?
        VIM::command("redraw!")
        VIM::message("No changes made.")
        return
      end
  
      # toggle blocked value based on current value
      new_value = !task.blocked?

      new_value_display = (new_value == true) ? "blocked" : "unblocked"
      update_msg = "Successfully #{new_value_display} #{task_formatted_id}."

    else
      new_value = VIM::evaluate("input('#{task_display}\n[Esc to Cancel] Enter #{@field_label} (#{task_unit_name}): ')")
      update_msg = "Successfully updated #{task_formatted_id}.  [#{@field_label}: #{new_value} #{task_unit_name}]"

      new_value.lstrip!   # remove any pre/post whitespace
      new_value.rstrip!

      # return if user Escaped or entered no value
      if new_value.empty?
        VIM::command("redraw!")
        VIM::message("No changes made to #{task_formatted_id}.")
        return
      end

    end

    # clear screen
    VIM::command("redraw!")

    progress = ProgressBar.new("Updating task #{task_formatted_id}", 3)
    progress.increment
    # perform update
    begin
      task.update(@field_method => new_value)
      progress.increment
      # request reload if updating task in details window
      ReloadController.new(task)
      progress.increment
      VIM::message(update_msg)
    rescue => e
      VIM::message("Error updating task #{task_formatted_id}. " + e.message)
      return
    ensure
      progress.close
    end

  end
end
