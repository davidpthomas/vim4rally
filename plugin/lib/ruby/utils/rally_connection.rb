require 'rubygems'
require 'rally_rest_api'
require 'yaml'

# This class represents the connection to Rally.
class RallyConnection

  attr_reader :rally
  attr_reader :username, :base_url, :version
  attr_reader :workspace        # cache of workspace info
  attr_reader :project
  attr_reader :iteration
  attr_reader :debug
  attr_reader :props
  attr_reader :vars

  # Load and set rally connection properties
  def initialize()

    begin
      prop_file = VIM::evaluate("g:rally_vars['property_file']") 
      @props = YAML::load(File.open(prop_file))
    rescue Exception => e
      raise RallyPropertiesError, "Error loading properties #{e.message}."
    end
    @username = @props["username"]
    @password = @props["password"]
    @base_url = @props["base_url"]
    @version = @props.has_key?("version") ? @props["version"].to_s : nil
    @default_workspace_name = @props["workspace"]
    @default_project_name = @props["project"]
    @log_file = @props["log_file"]
    @debug = @props["debug"]

    @vars = VIM::evaluate("g:rally_vars")

    raise RallyUsernameRequired, "Rally username is required." if @username.nil? || @username.empty?
    raise RallyPasswordRequired, "Rally password is required." if @password.nil? || @password.empty?
    raise RallyBaseUrlRequired, "Rally base url is required." if @base_url.nil? || @base_url.empty?
    raise RallyVersionRequired, "Rally version is required." if @version.nil? || @version.empty?

  end

  # Connect to Rally
  def connect
    begin

      # TODO: exception handling on log file existence, etc.
      logger = (@log_file.nil?) ? nil : Logger.new(File.open(@log_file, File::CREAT | File::TRUNC | File::RDWR), 0644)

      @rally = RallyRestAPI.new(:username => @username,
                                :password => @password,
                                :base_url => @base_url,
                                :version => @version,
                                :logger => logger)
    rescue Exception => e
      raise RallyConnectError, "Unable to connect to Rally. #{e.message}"
    end

  end

  # Obtain reference to given workspace; default to workspace given in prop file
  def load_workspace(workspace_name = @default_workspace_name, project_name = @default_project_name)
    tip_text = "\\\\" + $conn.vars["keys"]["quickhelp"] + " for help"
    progress = ProgressBar.new("Connecting to Rally...  [ #{tip_text} ] ", 7)
    progress.increment

    # load required workspace info
    begin
      @workspace = Workspace.find_by_name(workspace_name)
      @workspace.cache_workspace
        progress.increment
      @workspace.cache_workspace_config
        progress.increment

      # set prefixes since these are not available via rally api
      @workspace.prefix_userstory = @props["prefix_userstory"]
      @workspace.prefix_task = @props["prefix_task"]
      @workspace.prefix_defect = @props["prefix_defect"]
      @workspace.prefix_defectsuite = @props["prefix_defectsuite"]
      @workspace.prefix_testcase = @props["prefix_testcase"]
        progress.increment

      VIM::command("let g:rally_vars['workspace_name'] = '#{@workspace.name}'")

    rescue Exception => e
      raise RallyWorkspaceNotFound, "Unable to find workspace '#{workspace_name}'."
      progress.close
    end

    # load optional project info
    begin
      if !project_name.empty?
        @project = Project.find_by_name(project_name)
      end
    rescue Exception => e
      # DO NOTHING; Project is optional
    ensure
        progress.increment
    end

    # load optional current iteration info
    begin
      @iteration = Iteration.find_current

    rescue Exception => e
      # DO NOTHING; Iteration is optional
    ensure
        progress.increment
    end

    if !@iteration.nil?
      VIM::command("let g:rally_vars['iteration_name'] = '#{@iteration.name}'")
    else
      VIM::command("let g:rally_vars['iteration_name'] = 'No Iteration'")
    end

    progress.close
  end

  def has_project?
    return (@project.nil?) ? false : true
  end

  def has_iteration?
    return (@iteration.nil?) ? false : true
  end


  def to_s
    "username: #{@username}, password: #{@password}, base_url: #{@base_url}, version: #{@version}"
  end

end

# Exceptions
class RallyPropertiesError < StandardError; end
class RallyBaseUrlRequired < StandardError; end
class RallyVersionRequired < StandardError; end
class RallyUsernameRequired < StandardError; end
class RallyPasswordRequired < StandardError; end
class RallyWorkspaceNotFound < StandardError; end
class RallyObjectNotFound < StandardError; end
class RallyConnectError < StandardError; end
class RallyNoSelection < StandardError; end

