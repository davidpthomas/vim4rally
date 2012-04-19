class RallyController

  def initialize
    execute   # define in subclass
  end

  private

  # Code to be executed in the context of the controller
  # Each subclass must override and define.
  def execute
    raise "Reminder: This method must be overridden by subclass controllers."
  end
end
