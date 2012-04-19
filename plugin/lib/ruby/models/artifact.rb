# This class wraps the (abstract) Rally REST artifact (user story, defect, etc).
# This is expected to be used only by multiple result search querying.
class Artifact < RallyObject

  # wrap the rally REST object
  def initialize(artfact_ref)
    @ref = artifact_ref
  end

  def self.find_blocked_by_owner(owner)
    query_results = $conn.rally.find(:hierarchicalrequirement,
                                     :workspace => $conn.workspace,
                                     :project_scope_up => true,
                                     :project_scope_down => true) { 
                                                                    equal :owner, owner
                                                                    equal :blocked, 'true'
                                                                  }

    # augment result objects with knowledge of their type (e.g. defect, testcase, etc)
    query_results.results.each do |result|
      result.extend(IsType) # incorporate methods such as is_defect?, is_userstory?, etc.
    end

    query_results.results

  end

  def self.find_by_text(text)
    query_results = $conn.rally.find(:artifact,
                                     :workspace => $conn.workspace,
                                     :project_scope_up => true,
                                     :project_scope_down => true) { 
                                                                    _or_ {
                                                                      contains :name, text
                                                                      contains :description, text
                                                                      }
                                                                  }

    # augment result objects with knowledge of their type (e.g. defect, testcase, etc)
    query_results.results.each do |result|
      result.extend(IsType) # incorporate methods such as is_defect?, is_userstory?, etc.
    end

    query_results.results
  end

  def to_s
  end
end
