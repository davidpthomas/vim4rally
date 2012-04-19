class UpdateTaskEstimateController < UpdateTaskController

  def initialize
    # label, method in rally API
    super("Estimate", :estimate)
  end

end
