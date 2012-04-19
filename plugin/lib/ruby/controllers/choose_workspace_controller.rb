class ChooseWorkspaceController < RallyController

  def initialize
    super()
  end

  def execute

    progress = ProgressBar.new("Loading Workspaces...", 3)
    progress.increment

    workspaces = Workspace.find_all
    progress.increment

    workspace_list = []

    begin
      # generate the list outside of the list picker widget since calling '.name' is
      # a rally hit for each call so we want to show progress bar status.
      workspaces.each_index do |index|
        workspace_list << workspaces[index].name
      end
      progress.increment
    ensure
      progress.close
    end

    list_picker = ListPicker.new("Rally Workspace", workspace_list)
    selected_index = list_picker.prompt_user

    $conn.load_workspace(workspace_list[selected_index])
  end
end

