require 'tzinfo'
require 'date'

# This class wraps a Rally REST task.  It mostly
# serves as a proxy, still taking advantage of the dyanmic nature of the REST object,
# however for display purposes, some methods can be overriden/hijacked.
class Workspace < RallyObject

  # these prefixes are not available via Rally API so they are set externally
  attr_accessor :prefix_userstory, :prefix_task, :prefix_defect
  attr_accessor :prefix_defectsuite, :prefix_testcase

  # wrap the rally REST object
  def initialize(workspace_ref)
    @ref = workspace_ref
  end

  # split out for progress meter
  def cache_workspace
    # cache much of the workspace to prevent frequent/redundant calls to rally
    cache(:object_id, @ref.object_i_d)
    cache(:name, @ref.name)
    cache(:state, @ref.state)

    schedule_states = []
    story_typedef = @ref.type_definitions.find {|t| t.name == "Hierarchical Requirement"}
    state_attr = story_typedef.attributes.find {|a| a.name == "Schedule State"}
    state_attr.allowed_values.each {|v| schedule_states << v[:string_value]}

    cache(:schedule_states, schedule_states)
  end

  # split out for progress meter
  def cache_workspace_config
    ws_config = @ref.workspace_configuration
    cache(:iteration_estimate_unit_name, ws_config.iteration_estimate_unit_name)
    cache(:release_estimate_unit_name, ws_config.release_estimate_unit_name)
    cache(:task_unit_name, ws_config.task_unit_name)
    cache(:time_zone, ws_config.time_zone)
    cache(:work_days, ws_config.work_days.split(',').map! {|x| x.upcase}) # uppercase names and convert to array
    cache(:date_format, ws_config.date_format)
    cache(:date_time_format, ws_config.date_time_format)
  end

  def is_workday?(date_str_utc)
    tz = TZInfo::Timezone.get(self.time_zone)
    day = tz.utc_to_local(DateTime.parse(date_str_utc)).strftime("%A")
    self.work_days.include?(day.upcase)
  end

  # Lookup all workspaces
  def self.find_all()
    ws_refs = []
    query_results = $conn.rally.user.subscription.workspaces.find_all { |w| w.state == "Open" }
    query_results.each do |ws_ref|
      ws_refs << self.new(ws_ref)
    end
    ws_refs
  end

  # Lookup workspace by name
  def self.find_by_name(name)
    ws_ref = $conn.rally.user.subscription.workspaces.find { |ws| ws.name == name }
    raise RallyWorkspaceNotFound, "Workspace '#{name}' not found." if ws_ref.nil?
    self.new(ws_ref)
  end

  def to_s
    "#{@ref.formatted_i_d} - #{@ref.name}"
  end
end
