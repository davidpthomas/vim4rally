
# This class wraps a Rally REST hierarchical requirement (user story).  It mostly
# serves as a proxy, still taking advantage of the dyanmic nature of the REST object,
# however for display purposes, some methods can be overriden/hijacked.
class UserStory < RallyObject

  # wrap the rally REST object
  def initialize(story_ref)
    @ref = story_ref
  end

  # show 'N/A' instead of nil if story has no plan estmate
  def plan_estimate
    est = @ref.plan_estimate    # proxy call to get original value
    return (est.nil?) ? "N/A" : est
  end

  def has_parent?
    return (!@ref.portfolio_item.nil? || !@ref.parent.nil?) ? true : false
  end

  def parent_formatted_id
    formatted_id = ""
    if !@ref.parent.nil?
      formatted_id = @ref.parent.formatted_i_d
    elsif !@ref.portfolio_item.nil?
      formatted_id = @ref.portfolio_item.formatted_i_d
    end
    return formatted_id
  end

  def parent_name
    name = ""
    if !@ref.parent.nil?
      name = @ref.parent.name
    elsif !@ref.portfolio_item.nil?
      name = @ref.portfolio_item.name
    end
    return name
  end

  # Lookup a story by Rally Id.  Id can be just numeric (e.g. 33)
  def self.find_by_id(id)

    query_result = $conn.rally.find(:hierarchical_requirement,
                                    :workspace => $conn.workspace,
                                    :project_scope_up => true,
                                    :project_scope_down => true) {equal :formatted_i_d, id}
    raise RallyObjectNotFound, "Unable to find user story for id [#{id}]." if query_result.total_result_count == 0
    story_ref = query_result.results[0]
    self.new(story_ref)
  end

  def to_s
    "#{@ref.formatted_i_d} - #{@ref.name}"
  end
end

