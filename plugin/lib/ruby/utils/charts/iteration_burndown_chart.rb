class IterationBurndownChart < Chart

  def initialize(iteration_name, icf_data, num_horiz_lines)
    super(num_horiz_lines)
    @iteration_name = iteration_name
    @icf_data = icf_data

  end

  def draw
    draw_title("Iteration Burndown Chart")
    draw_subtitle("#{$conn.project.name} - #{@iteration_name}")
    draw_legend("[#] Task To Do (#{$conn.workspace.task_unit_name})    [@] Accepted (#{$conn.workspace.iteration_estimate_unit_name})")
    draw_vert_axes_labels('.')
    draw_horiz_axes_labels
    draw_trendline
    draw_data
    reset_cursor
  end

  private

  def draw_trendline
    slope = - (@chart_height.to_f / @chart_width)

    for x in @chart_left+1..@chart_width do
      y = ( slope * x ) + chart_top # y = mx + b :)
      point(x, y, '-')  if x % (6) == 0
    end
  end

  def draw_data

    total_workdays = @icf_data.total_workdays
    display_col_max_width = ((@chart_width - 6) / total_workdays).floor
    display_col_width = display_col_max_width - 1       # separator between data columns
    data_col_width = (display_col_width / 2).floor
    data_col_next_offset = ((@chart_width - 6) / total_workdays).floor

    # half of max possible flanking space assuming all data cols are only 1-space apart
    left_start_offset = ((@chart_width - (data_col_next_offset * total_workdays)) / 2.0).ceil
    left_start = ((@window.width - @chart_width) / 2) + left_start_offset   # start at 1/2 label breathing room
    axis_bottom_side_offset = @chart_bottom_offset

    data_col_cnt = 1

    max_card_to_do = @icf_data.max_card_to_do
    max_accepted = @icf_data.max_card_estimate

    @icf_data.results_by_day.each do |data|

      # left start of current col pair
      todo_col_left_start = left_start + ((data_col_cnt - 1) * data_col_next_offset)
      accepted_col_left_start = left_start + data_col_width + ((data_col_cnt - 1) * data_col_next_offset)
      # height of each col in pair
      todo_height = ((data.total_card_to_do.to_f / max_card_to_do) * @chart_height).floor
      accepted_height = ((data.total_accepted.to_f / max_accepted) * @chart_height).floor

      # draw lines for each pair
      for x in 1..data_col_width do
        # todo
        vert_line(todo_col_left_start + x, 0, todo_height, axis_bottom_side_offset, '#')
        #accepted
        vert_line(accepted_col_left_start + x, 0, accepted_height, axis_bottom_side_offset, '@')
      end

      if data.total_card_to_do.to_f > 0 then
        if data.total_card_to_do > 0.5   # round to x.y precision
          todo_col_label = sprintf("%.1f", data.total_card_to_do.to_f)
        else # round to x.yy precision
          todo_col_label = sprintf("%.2f", data.total_card_to_do.to_f)
        end
        text(todo_col_left_start + 1 + ((data_col_width - todo_col_label.length)/2.0).floor, axis_bottom_side_offset + todo_height, todo_col_label)
      end
      if data.total_accepted.to_i > 0 then
        accepted_col_label = "#{sprintf("%.1f", data.total_accepted.to_f)}"
        text(accepted_col_left_start + 1 + ((data_col_width - accepted_col_label.length)/2.0).floor, axis_bottom_side_offset + accepted_height, accepted_col_label)
      end

      data_col_cnt += 1   # next col pair
    end
  end

  def draw_horiz_axes_labels
    left_label = @icf_data.start_date.strftime("%a %m-%d-%Y")
    middle_label = @icf_data.middle_date.strftime("%a %m-%d-%Y")
    right_label = @icf_data.end_date.strftime("%a %m-%d-%Y")
    chart_horiz_labels(left_label, middle_label, right_label)
  end

  def draw_vert_axes_labels(char)

    # visual bars
    task_unit_suffix = $conn.workspace.task_unit_name[0,1]               # show first letter
    est_unit_suffix = $conn.workspace.iteration_estimate_unit_name[0,1]  # show first letter
    chart_horiz_lines(char,
                      @icf_data.max_card_to_do, task_unit_suffix,
                      @icf_data.max_card_estimate, est_unit_suffix)

  end

end
