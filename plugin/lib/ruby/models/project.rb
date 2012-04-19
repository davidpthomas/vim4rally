# This class wraps a Rally REST task.  It mostly
# serves as a proxy, still taking advantage of the dyanmic nature of the REST object,
# however for display purposes, some methods can be overriden/hijacked.
class Project < RallyObject

  # wrap the rally REST object
  def initialize(project_ref)
    @ref = project_ref
  end

  # lookup by name
  def self.find_by_name(name)
    project_ref = $conn.workspace.projects.find { |p| p.name == name && p.state == "Open" }
    raise RallyObjectNotFound, "Project #{name} not found." if project_ref.nil?
    self.new(project_ref)
  end

  def to_s
    "#{@ref.object_i_d} - #{@ref.name}"
  end
end
