# This class wraps a Rally REST task.  It mostly
# serves as a proxy, still taking advantage of the dyanmic nature of the REST object,
# however for display purposes, some methods can be overriden/hijacked.
class Task < RallyObject

  # wrap the rally REST object
  def initialize(task_ref)
    @ref = task_ref
  end

  # Lookup a task by Rally Id.  Id can be just numeric (e.g. 33)
  def self.find_by_id(id)

    query_result = $conn.rally.find(:task,
                                    :workspace => $conn.workspace,
                                    :project_scope_up => true,
                                    :project_scope_down => true,
                                    :fetch => true) {equal :formatted_i_d, id}
    raise RallyObjectNotFound, "Unable to find user task for id [#{id}]." if query_result.total_result_count == 0
    task_ref = query_result.results[0]
    self.new(task_ref)
  end

  def self.find_by_owner(owner)
    task_refs = []
    query_results = $conn.rally.find(:task,
                                     :workspace => $conn.workspace,
                                     :project_scope_up => true,
                                     :project_scope_down => true) {equal :owner, owner}
    query_results.each do |task_ref|
      task_refs << self.new(task_ref)
    end
    task_refs
  end

  # update values in Rally for current task
  def update(updates = {})
    @ref.update(updates)
  end

  def to_s
    "#{@ref.formatted_i_d} - #{@ref.name}"
  end
end
