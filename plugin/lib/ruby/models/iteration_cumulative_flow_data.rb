# This class wraps a Rally REST task.  It mostly
# serves as a proxy, still taking advantage of the dyanmic nature of the REST object,
# however for display purposes, some methods can be overriden/hijacked.
class IterationCumulativeFlowData

  attr_reader :iteration
  attr_reader :results_by_day       # { creation_date => ICFDayData }
  attr_reader :total_workdays

  def initialize(iteration, results)
    @iteration = iteration
    @results_by_day = organize_results_by_day(results)
    @total_workdays = calculate_workdays
  end

  # Lookup a task by Rally Id.  Id can be just numeric (e.g. 33)
  def self.find_by_iteration(iteration)

    query_result = $conn.rally.find(:iteration_cumulative_flow_data,
                                    :workspace => $conn.workspace,
                                    :project => $conn.project,
                                    :fetch => true,
                                    :pagesize => 100,
                                    :project_scope_up => false,
                                    :project_scope_down => false) {equal :iteration_object_i_d, iteration.object_i_d }

    raise RallyObjectNotFound, "Unable to find cumulative flow data for iteration [#{iteration.name}]." if query_result.total_result_count == 0
    # data returned is an array of sequential (by relative day) card state/count data
    # e.g. [Accepted {blah}, Completed {blah}, In Progress {blah}, Backlog {blah}, Accepted {blah}, ....]
    self.new(iteration, query_result.results)
  end

  def start_date
    Date.parse(@iteration.start_date)
  end

  def middle_date
    Date.parse(@results_by_day[(total_days / 2.0).to_i].creation_date)
  end

  def end_date
    Date.parse(@iteration.end_date)
  end

  def total_days
    @results_by_day.size
  end

  def max_card_estimate
    max = 0
    @results_by_day.each do |day_data|
      max = day_data.total_card_estimate if day_data.total_card_estimate > max
    end
    max
  end

  def max_DPCA_card_estimate
    max = 0
    @results_by_day.each do |day_data|
      max = day_data.total_DPCA_card_estimate if day_data.total_DPCA_card_estimate > max
    end
    max
  end

  def max_card_to_do
    max = 0
    @results_by_day.each do |day_data|
      max = day_data.total_card_to_do if day_data.total_card_to_do > max
    end
    max
  end

  def to_s
    "total_days [#{total_days}] max_card_estimate [#{max_card_estimate}] max_card_to_do [#{max_card_to_do}]"
  end

  private

  # original results format
  # date 1, state 1, (data)
  # date 1, state 2, (data)
  # date 2, state 1, (data)
  #
  # ["creation_date" => 2011.01.01, "state_data" => {Accepted => data, Completed => data...}
  # ["creation_date" => 2011.01.01, "state_data" => {Accepted => data, Completed => data...}
  def organize_results_by_day(results)
    results_by_day = []

    results.each do |result|
      if results_by_day.last.nil? || results_by_day.last["creation_date"] != result.creation_date
        results_by_day << { "creation_date" => result.creation_date, "state_data" => {} }
      end
      results_by_day.last["state_data"][result.card_state] = {
        "card_count" => result.card_count,
        "card_estimate_total" => result.card_estimate_total,
        "card_to_do_total" => result.card_to_do_total,
        "task_estimate_total" => result.task_estimate_total
      }
    end

    data_by_day = []
    results_by_day.each do |result_by_day|
       data_by_day << IterationCumulativeFlowDayData.new(result_by_day["creation_date"], result_by_day["state_data"])
    end

    data_by_day
  end

  # determine how many days in the iteration are considered 'workdays' as
  # defined by the workspace configuration
  def calculate_workdays
    iteration_start_date = Date.parse(@iteration.start_date)
    iteration_end_date = Date.parse(@iteration.end_date)
    total_iteration_days = iteration_end_date - iteration_start_date + 1
    # number of total possible workdays within entire iteration
    total_workdays = 0
    curr_day = iteration_start_date
    for i in 1..total_iteration_days
      total_workdays += 1 if $conn.workspace.is_workday?(curr_day.to_s)
      curr_day += 1
    end
    total_workdays
  end
end

# ICF Record represents a single day and unique collection of states (Accepted, Completed, etc)
class IterationCumulativeFlowDayData

  attr_reader :creation_date

  # state_data is a hash of schedule states and associated icf data
  def initialize(creation_date, state_data)
    @creation_date = creation_date
    @state_data = state_data
  end

  def total_defined
    @state_data["Defined"]["card_estimate_total"].to_f
  end

  def total_in_progress
    @state_data["In-Progress"]["card_estimate_total"].to_f
  end

  def total_completed
    @state_data["Completed"]["card_estimate_total"].to_f
  end

  def total_accepted
    @state_data["Accepted"]["card_estimate_total"].to_f
  end

  def total_DPCA_card_estimate
    sum = 0
    @state_data.each do |state, data|
      if state == "Defined" || state == "In-Progress" || state == "Completed" || state == "Accepted"
        sum += data["card_estimate_total"].to_f
      end
    end
    sum
  end

  def total_card_estimate
    sum = 0
    @state_data.each do |state, data|
      sum += data["card_estimate_total"].to_f
    end
    sum
  end

  def total_task_estimate
    sum = 0
    @state_data.each do |state, data|
      sum += data["task_estimate_total"].to_f
    end
    sum
  end

  def total_card_to_do
    sum = 0
    @state_data.each do |state, data|
      sum += data["card_to_do_total"].to_f
    end
    sum
  end

  def to_s
    "creation_date [#{@creation_date}] total_card_estimate [#{total_card_estimate}] total_accepted [#{total_accepted}] total_task_estimate [#{total_task_estimate}] total_card_to_do [#{total_card_to_do}]"
  end
end
