# Class for managing search criteria and results.  Instances need
# to be created as the search strategy is determined based on the
# current environment (e.g. current line) or user input.
class Info

  def initialize
  end

  def name
    "info"
  end

  def title
    "Rally Info"
  end

  def formatter
    InfoFormatter.new
  end
end

