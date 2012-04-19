require 'erb'

# Content formatter for a single user story.
class InfoFormatter < Formatter
  def initialize
    super()
  end

  def content
    template_contents = load_view_template("info")
    erb_template = ERB.new(template_contents, 0, "%<>")

    managed_display_window = ManagedDisplayWindow

    content = erb_template.result(binding)
    content
  end
end
