require 'erb'

# Content formatter for a single user story.
class TaskSingleFormatter < Formatter
  def initialize(results)
    super()
    @task = results
  end

  def content
    template_contents = load_view_template("task_by_id")
    erb_template = ERB.new(template_contents, 0, "%<>")
    conn = $conn
    task = @task

    content = erb_template.result(binding)
    content
  end

  def formatted_id
    @task.formatted_i_d
  end
end
