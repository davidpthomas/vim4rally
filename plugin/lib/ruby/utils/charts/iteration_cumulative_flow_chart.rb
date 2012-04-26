class IterationCumulativeFlowChart < Chart

  def initialize(iteration_name, icf_data, num_horiz_lines)
    super(num_horiz_lines)
    @iteration_name = iteration_name
    @icf_data = icf_data

  end

  def draw
    draw_title("Iteration Cumulative Flow Diagram")
    draw_subtitle("#{$conn.project.name} - #{@iteration_name}")
    draw_legend("[*] Defined   [#] In-Progress   [%] Completed   [@] Accepted")
    draw_vert_axes_labels('.')
    draw_horiz_axes_labels
    draw_data
    reset_cursor
  end

  private

  def draw_data

    total_workdays = @icf_data.total_workdays
    display_col_max_width = ((@chart_width - 6) / total_workdays).floor
    display_col_width = display_col_max_width - 0       # NO separator between data columns
    data_col_width = (display_col_width).floor
    data_col_next_offset = ((@chart_width - 6) / total_workdays).floor

    # half of max possible flanking space assuming all data cols are only 1-space apart
    left_start_offset = ((@chart_width - (data_col_next_offset * total_workdays)) / 2.0).ceil
    left_start = ((@window.width - @chart_width) / 2) + left_start_offset   # start at 1/2 label breathing room
    axis_bottom_side_offset = @chart_bottom_offset

    data_col_cnt = 1

    @icf_data.results_by_day.each do |data|

      # left start of current col pair
      col_left_start = left_start + ((data_col_cnt - 1) * data_col_next_offset)
      # height of each col in pair

      total_estimate = data.total_DPCA_card_estimate

      accepted_height = ((adjust_fraction(data.total_accepted) / total_estimate) * @chart_height).ceil
      completed_height = ((adjust_fraction(data.total_completed) / total_estimate) * @chart_height).ceil
      in_progress_height = ((adjust_fraction(data.total_in_progress) / total_estimate) * @chart_height).ceil
      defined_height = ((adjust_fraction(data.total_defined) / total_estimate) * @chart_height)

      accepted_start_height = 0
      accepted_end_height = accepted_height
      completed_start_height = accepted_end_height
      completed_end_height = completed_start_height + completed_height
      in_progress_start_height = completed_end_height
      in_progress_end_height = in_progress_start_height + in_progress_height
      defined_start_height = in_progress_end_height
      defined_end_height = in_progress_end_height + defined_height
      defined_end_height = @chart_height    # Note: Forcing to chart height helps with ceil rounding of additive I/C/A values

      # draw lines for each pair
      for x in 1..data_col_width do
        # accepted
        vert_line(col_left_start + x, accepted_start_height, accepted_end_height, axis_bottom_side_offset, '@')
        # completed
        vert_line(col_left_start + x, completed_start_height, completed_end_height, axis_bottom_side_offset, '%')
        # in progress
        vert_line(col_left_start + x, in_progress_start_height, in_progress_end_height, axis_bottom_side_offset, '#')
        # defined
        vert_line(col_left_start + x, defined_start_height, defined_end_height, axis_bottom_side_offset, '*')
      end

      if data.total_DPCA_card_estimate > 0 then
        formatted_total_DPCA_card_estimate = sprintf("%.1f", data.total_DPCA_card_estimate)
        col_label = "[#{formatted_total_DPCA_card_estimate}]"
        text(col_left_start + 1 + ((data_col_width - col_label.length)/2.0).floor, axis_bottom_side_offset + defined_end_height, col_label)
      end

      # show accepted points at top of accepted area
      if data.total_accepted > 0 then
        formatted_total_accepted = sprintf("%.1f", data.total_accepted)
        col_label = "[#{formatted_total_accepted}]"
        text(col_left_start + 1 + ((data_col_width - col_label.length)/2.0).floor, axis_bottom_side_offset + accepted_end_height - 1, col_label)
      end

      data_col_cnt += 1   # next col
    end
  end

  def adjust_fraction(num)
    return (num < num.floor + 0.5)? num.floor : num.ceil
  end

  def draw_horiz_axes_labels
    left_label = @icf_data.start_date.strftime("%a %m-%d-%Y")
    middle_label = @icf_data.middle_date.strftime("%a %m-%d-%Y")
    right_label = @icf_data.end_date.strftime("%a %m-%d-%Y")
    chart_horiz_labels(left_label, middle_label, right_label)
  end

  def draw_vert_axes_labels(char)

    # visual bars
    est_unit_suffix = $conn.workspace.iteration_estimate_unit_name[0,1]  # show first letter
    chart_horiz_lines(char, @icf_data.max_DPCA_card_estimate, est_unit_suffix,
                      nil, nil)

  end

end
