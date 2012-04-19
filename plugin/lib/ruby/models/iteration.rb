# This class wraps a Rally REST task.  It mostly
# serves as a proxy, still taking advantage of the dyanmic nature of the REST object,
# however for display purposes, some methods can be overriden/hijacked.
class Iteration < RallyObject

  # wrap the rally REST object
  def initialize(ref)
    @ref = ref
  end

  # Lookup all iterations
  def self.find_all()
    refs = []
    query_results = $conn.rally.find(:iteration,
                                     :workspace => $conn.workspace,
                                     :project => $conn.project,
                                     :project_scope_up => false,
                                     :project_scope_down => false)
    query_results.each do |iteration_ref|
      refs << self.new(iteration_ref)
    end

    refs
  end


  # lookup by name
  def self.find_by_name(name)

    query_result = $conn.rally.find(:iteration,
                                    :workspace => $conn.workspace,
                                    :project => $conn.project,
                                    :project_scope_up => false,
                                    :project_scope_down => false) {contains :name, name }

    iteration_ref = query_result.results[0]
    raise RallyObjectNotFound, "Iteration #{name} not found." if iteration_ref.nil?

    self.new(iteration_ref)
  end

  def self.find_current

    curr_date = Date.today.strftime("%Y-%m-%d")   # ISO 8601 format

# DEBUG TEST PREVIOUS ITERATION
#curr_date = "2011-12-19"

    query_result = $conn.rally.find(:iteration,
                                    :workspace => $conn.workspace,
                                    :project => $conn.project,
                                    :project_scope_up => false,
                                    :project_scope_down => false,
                                    :fetch => true) {
                                             greater_than_equal :end_date, curr_date
                                             less_than_equal :start_date, curr_date }

    iteration_ref = query_result.results[0]
    raise RallyObjectNotFound, "Iteration for current date [#{curr_date}] not found." if iteration_ref.nil?

    self.new(iteration_ref)

  end

  def to_s
    "#{@ref.name}"
  end
end
