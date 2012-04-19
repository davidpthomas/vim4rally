class ChooseIterationController < RallyController

  def initialize
    super()
  end

  def execute

    progress = ProgressBar.new("Loading Iterations...", 3)
    progress.increment

    iterations = Iteration.find_all
    progress.increment

    iteration_list = []

    begin
      # generate the list outside of the list picker widget since calling '.name' is
      # a rally hit for each call so we want to show progress bar status.
      iterations.each_index do |index|
        iteration_list << iterations[index].name
      end
      progress.increment
    ensure
      progress.close
    end

    list_picker = ListPicker.new("Rally Iteration", iteration_list)
    selected_index = list_picker.prompt_user

    #$conn.load_iteration(iteration_list[selected_index])
  end
end

