# Provides 'late loading' of the rally workspace info as this is
# an expensive call.  Ideally called the first time the Rally
# integration is used, rather than on vim startup.
class LoadWorkspaceController < RallyController

  def initialize
    super()
  end

  private

  # Create the connection context to provide access to Rally
  def execute
    $conn.load_workspace
  end
end
