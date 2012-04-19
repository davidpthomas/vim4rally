require 'erb'

# Content formatter for a single user story.
class DefectSingleFormatter < Formatter
  def initialize(results)
    super()
    @defect = results
  end

  def content
    template_contents = load_view_template("defect_by_id")
    erb_template = ERB.new(template_contents, 0, "%<>")
    conn = $conn
    defect = @defect

    content = erb_template.result(binding)
    content
  end

  def formatted_id
    @defect.formatted_i_d
  end
end
