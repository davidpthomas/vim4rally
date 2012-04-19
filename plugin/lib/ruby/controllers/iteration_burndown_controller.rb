class IterationBurndownController < RallyController

  def initialize
    super()
  end

  def execute

    p = ProgressBar.new("Building Burndown Chart...", 5)
    p.increment

    iteration = $conn.iteration
    p.increment

    icf_data = IterationCumulativeFlowData.find_by_iteration(iteration)
    p.increment

    num_horiz_lines = 4   # number of background scale lines to show; used to scale chart height & data
    c = IterationBurndownChart.new(iteration.name, icf_data, num_horiz_lines)
    p.increment

    c.draw 
    p.increment

    p.close
  end
end

