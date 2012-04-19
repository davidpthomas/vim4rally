# This class wraps a Rally REST defect.  It mostly
# serves as a proxy, still taking advantage of the dyanmic nature of the REST object,
# however for display purposes, some methods can be overriden/hijacked.
class Defect < RallyObject

  # wrap the rally REST object
  def initialize(defect_ref)
    @ref = defect_ref
  end

  # Lookup a defect by Rally Id.  Id can be just numeric (e.g. 33)
  def self.find_by_id(id)

    query_result = $conn.rally.find(:defect,
                                    :workspace => $conn.workspace,
                                    :project_scope_up => true,
                                    :project_scope_down => true) {equal :formatted_i_d, id}
    raise RallyObjectNotFound, "Unable to find user defect for id [#{id}]." if query_result.total_result_count == 0
    defect_ref = query_result.results[0]
    self.new(defect_ref)
  end

  def self.find_by_owner(owner)
    defect_refs = []
    query_results = $conn.rally.find(:defect,
                                     :workspace => $conn.workspace,
                                     :project_scope_up => true,
                                     :project_scope_down => true) {equal :owner, owner}
    query_results.each do |defect_ref|
      defect_refs << self.new(defect_ref)
    end
    defect_refs
  end

  def to_s
    "#{@ref.formatted_i_d} - #{@ref.name}"
  end
end
