require 'erb'

# Content formatter for a single user story.
class UserStorySingleFormatter < Formatter
  def initialize(results)
    super()
    @story = results
  end

  def content
    template_contents = load_view_template("story_by_id")
    erb_template = ERB.new(template_contents, 0, "%<>")
    conn = $conn
    story = @story

    content = erb_template.result(binding)
    content
  end

  def formatted_id
    @story.formatted_i_d
  end

end

