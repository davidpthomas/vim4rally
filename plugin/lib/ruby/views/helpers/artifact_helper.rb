module ArtifactHelper

  require 'tzinfo'

  def format_date(date_utc)
    tz = TZInfo::Timezone.get($conn.workspace.time_zone)
    tz.strftime("%Y/%m/%d-%I:%M:%S%Z", DateTime.parse(date_utc)).to_s
  end

  def formatted_tasks(tasks)
    tasks_display = []
    tasks.each do |task|
      blocked = (task.blocked == "true") ? "BLOCKED" : ""   # syntax highlighting matches 'BLOCKED' word
      tasks_display << task.formatted_i_d.ljust(7, ' ') + StringUtils.html2text(task.name).ljust(41, ' ')+ "#{task.estimate.rjust(8, ' ')}h " + "#{task.to_do.rjust(8, ' ')}h " + formatted_task_state(task.state).ljust(10, ' ') + formatted_owner(task.owner).ljust(10, ' ') + blocked + "\n"
    end
    # each task ends with \n; return all rows as single string
    tasks_display.join
  end

  def formatted_defects(defects)
    defects_display = []
    defects.each do |defect|
      blocked = (defect.blocked == "true") ? "BLOCKED" : ""   # syntax highlighting matches 'BLOCKED' word
      defects_display << defect.formatted_i_d.ljust(7, ' ') + StringUtils.html2text(defect.name)[0,41].ljust(41, ' ')+ "#{defect.priority[0,12].rjust(13, ' ')} " + "#{defect.state[0,13].rjust(13, ' ')} " + formatted_owner(defect.owner).ljust(10, ' ') + blocked + "\n"
    end
    # each defect ends with \n; return all rows as single string
    defects_display.join
  end

  def formatted_discussions(discussions)
    discussions_display = []
    discussions.each do |disc|
      discussions_display << format_date(disc.creation_date) + "|" + disc.user.display_name.ljust(10, ' ') + "| " + StringUtils.html2text(disc.text) + "\n"
    end
    # each discussion ends with \n; return all rows as single string
    discussions_display.join
  end

  def formatted_notes(notes)
    StringUtils.html2text(notes)
  end

  def formatted_owner(owner)
    display_owner = owner.nil? ? "" : owner.display_name
  end

  def formatted_story_state(state)
    avail_states = $conn.workspace.schedule_states
    # assume states are in rank order left-to-right
    display_str = ""
    avail_states.each do |s|
      state_first_char = "[#{s[0,1]}]"
      state_first_char = "[P]" if s == "In-Progress"
      state_first_char.upcase!
      display_str += state_first_char
      break if s == state
    end
    display_str
  end

  def formatted_task_state(state)
    avail_states = ["Defined","In-Progress", "Completed"]
    display_str = ""
    avail_states.each do |s|
      state_first_char = "[#{s[0,1]}]"
      state_first_char = "[P]" if state_first_char == "[I]"
      state_first_char.upcase!
      display_str += state_first_char
      break if s == state
    end
    display_str
  end

  def formatted_children(children)
    children_display = []
    get_children(children, 1, children_display)
    # each child ends with \n; return all rows as single string
    children_display.join
  end

  # recursively display children in nested format
  def get_children(children, level, array)
    return if children.nil?

    children.each do |child|
      
      blocked = (child.blocked == "true") ? "BLOCKED" : ""   # syntax highlighting matches 'BLOCKED' word
      display_str = " " * (level*2) + "#{child.formatted_i_d}: #{StringUtils.html2text(child.name)}"
      array << "#{display_str.rjust(display_str.length, ' ').ljust(65, ' ')} #{formatted_story_state(child.schedule_state).ljust(15, ' ')} #{blocked}\n"
      get_children(child.children, level+1, array)
    end
  end

  def formatted_iteration(iteration)
    (iteration.empty? ? "Unscheduled" : iteration.name)
  end

  def formatted_release(release)
    (release.empty? ? "Unscheduled" : release.name)
  end

  def formatted_blocked(blocked)
    (blocked) ? "BLOCKED" : ""   # syntax highlighting matches 'BLOCKED' word
  end
end
