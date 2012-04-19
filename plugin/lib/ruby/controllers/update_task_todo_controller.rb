class UpdateTaskTodoController < UpdateTaskController

  def initialize
    # label, method in rally API
    super("To do", :to_do)
  end

end
