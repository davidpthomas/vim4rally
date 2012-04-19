class UpdateTaskToggleBlockedController < UpdateTaskController

  def initialize
    # label, method in rally API
    super("Blocked", :blocked)
  end

end
