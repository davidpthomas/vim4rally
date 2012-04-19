require 'erb'

# Content formatter for a single user story.
class MultipleResultsFormatter < Formatter
  def initialize(results)
    super()
    @results = results
  end

  def content
    template_contents = load_view_template("multiple_results")
    erb_template = ERB.new(template_contents, 0, "%<>")
    conn = $conn
    results = @results

    results_by_type = {}
    results_by_type[conn.workspace.prefix_userstory] = []
    results_by_type[conn.workspace.prefix_task] = []
    results_by_type[conn.workspace.prefix_defect] = []
    results_by_type[conn.workspace.prefix_defectsuite] = []
    results_by_type[conn.workspace.prefix_testcase] = []

    results.each do |result|
      results_by_type[result.type_code] << result
    end

    content = erb_template.result(binding)
    content
  end
end
