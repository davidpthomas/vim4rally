# Chart represents the current vim window with 0, 0 in the lower left corner

#           canvas width
#          -------------------------------------------------------
#  canvas  |                  chart top offset                   |
#  height  |-----------------------------------------------------|
#          | s |                chart width                  | s |
#          | i |                                             | i |
#          | d |                                             | d |
#          | e | chart                                       | e |
#          |   | height                                      |   |
#          | o |                                             | o |
#          | f |                                             | f |
#          | f |                                             | f |
#          | s |                                             | s |
#          | e |                                             | e |
#          | t |                                             | t |
#          |-----------------------------------------------------|
#          |                 chart bottom offset                 |
#          -------------------------------------------------------
#
class Chart < Canvas

  attr_accessor :chart_left, :chart_right, :chart_bottom, :chart_top
  attr_accessor :chart_width, :chart_height

  # num horiz lines used to figure out true height of chart so the top line matches max data values
  def initialize(num_horiz_lines)
    super()

    @chart_top_offset = 5               # title/subtitle
    @chart_bottom_offset = 5            # legend
    @chart_side_offset = 6              # labels
    @num_horiz_lines = num_horiz_lines  # number of background horiz lines in chart

    # height/width of inset chart
    @max_chart_height = @window_height - @chart_top_offset - @chart_bottom_offset + 2
    @chart_height = ((@max_chart_height / num_horiz_lines).floor) * num_horiz_lines
    @chart_width = @window_width - ( 2 * @chart_side_offset )  # left and right side

    # helpers
    @chart_left = @chart_side_offset
    @chart_right = @chart_width - @chart_side_offset
    @chart_bottom = @chart_bottom_offset
    @chart_top = @chart_height + @chart_bottom_offset

    draw_axes
  end

  protected

  def draw_axes

    axis_left_col = @chart_side_offset
    axis_right_col = axis_left_col + @chart_width

    horiz_line(@chart_bottom_offset, @chart_width, axis_left_col, '_') # bottom axis
    vert_line(axis_left_col, 0, @chart_height, @chart_bottom_offset, '|') # left axis
    vert_line(axis_right_col, 0, @chart_height, @chart_bottom_offset, '|') # right axis

  end

  # Draw horizontal axes labels
  def chart_horiz_labels(label_left, label_middle, label_right)
    left_position_start = @chart_side_offset
    middle_position_start = @chart_side_offset + (@chart_width / 2.0).to_i - (label_middle.to_s.length / 2.0).to_i
    right_position_start = @canvas_width - @chart_side_offset - label_right.to_s.length
    text(left_position_start, @chart_bottom_offset - 1, label_left)
    text(middle_position_start, @chart_bottom_offset - 1, label_middle)
    text(right_position_start, @chart_bottom_offset - 1, label_right)
  end

  # Draw horizontal visual lines with % calculated labels on vertical axes
  def chart_horiz_lines(char, left_max_value, left_suffix, right_max_value, right_suffix)

    left_position_start = @chart_side_offset
    right_position_start = @canvas_width - @chart_side_offset

    height_incr_percent = 1.0 / @num_horiz_lines
    lines_per_increment = (@chart_height * height_incr_percent).floor
    line_width = @chart_width - 2  # inset within left/right axes
    side_offset = @chart_side_offset + 1  # account for left axis
    for line_num in 1..@num_horiz_lines do
      horiz_line( (@chart_bottom_offset - 1 + (line_num * lines_per_increment)), line_width, side_offset, char)
      if !left_max_value.nil?
        left_label = "[#{line_num * (left_max_value.to_f / @num_horiz_lines).floor}#{left_suffix}]"
        text((left_position_start - (left_label.size / 2)), ((line_num * lines_per_increment)+ @chart_bottom_offset - 1), left_label)
      end
      if !right_max_value.nil?
        right_label = "[#{line_num * (right_max_value.to_f / @num_horiz_lines).floor}#{right_suffix}]"
        text((right_position_start - (right_label.size / 2)), ((line_num * lines_per_increment)+ @chart_bottom_offset - 1), right_label)
      end
    end
  end

  # -------------------------------------------------
  # PRIMITIVES
  # -------------------------------------------------
  def vert_line(x, y, height, offset, char)
    return if height < 0.5
    for i in y..height - 1 do
      point(x, (i + offset), char) if i < @chart_height   # prevent drawing above the chart due to rounding
    end
  end

  def horiz_line(y, width, offset, char)
    return if width == 0
    for i in 0..width do
      point((i + offset), y, char)
    end
  end

  def point(x, y, char)
    @window.cursor = translate(x, y)
    write(char)
  end

  def text(x, y, text)
    @window.cursor = translate(x, y)
    write(text)
  end

  def cursor(x, y)
    @window.cursor = translate(x, y)
  end

  def write(text)
    VIM::command("normal R#{text}")
  end

  def reset_cursor
    # hack to re-orient the screen; it just works
    # - otherwise if you shrink the window, the cursor set may be shifted to the right
    text(0,@window.height,'')
    cursor(0,@window.height)   # upper left
  end

  def draw_title(title)
    x = (@window_width - title.size) / 2
    y = (@window_height - 1)
    text(x, y, title)
  end

  def draw_subtitle(subtitle)
    x = (@window_width - subtitle.size) / 2
    y = (@window_height - 2)
    text(x, y, subtitle)
  end


  def draw_legend(legend)
    text(((@window_width - legend.length) / 2).floor, 2, legend)
  end

  def debug(*args)
    args.each_index do |i|
    point(0,i+1,args[i])
    end
  end

  private

  # Translate 1-based points to vim's row/col based coord system
  def translate(x, y)
    # lines are top-to-bottom so flip vertical to be 0,0 lower left
    return @canvas_height - y + 1, x - 1
  end

end
