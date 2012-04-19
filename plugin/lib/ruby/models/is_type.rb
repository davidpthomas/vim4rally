# This module helps classify a result by type based on the contents
# of it's reference url e.g. https://rally1.rallydev.com/..../defect/1234565
module IsType

  # NOTE: REQUIRES THE 'rally' OBJECT BE AVAILABLE ON EXTENDED CLASS

  def type
    type = nil
    if is_userstory?
      type = "userstory"
    elsif is_task?
      type = "task"
    elsif is_defect?
      type = "defect"
    elsif is_defectsuite?
      type = "defectsuite"
    elsif is_testcase?
      type = "testcase"
    end
    type
  end

  def type_code
    type_code = nil
    if is_userstory?
      type_code = $conn.workspace.prefix_userstory
    elsif is_task?
      type_code = $conn.workspace.prefix_task
    elsif is_defect?
      type_code = $conn.workspace.prefix_defect
    elsif is_defectsuite?
      type_code = $conn.workspace.prefix_defectsuite
    elsif is_testcase?
      type_code = $conn.workspace.prefix_testcase
    end
    type_code
  end

  def is_requirement?
    ref.include? "requirement"
  end

  def is_userstory?
    ref.include? "requirement/"
  end

  def is_task?
    ref.include? "task/"
  end

  def is_defect?
    ref.include? "defect/"
  end

  def is_defectsuite?
    ref.include? "defectsuite/"
  end

  def is_testcase?
    ref.include? "testcase/"
  end

end

