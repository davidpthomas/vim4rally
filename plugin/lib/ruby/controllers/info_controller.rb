class InfoController < RallyController

  def initialize
    super()
  end

  def execute
    model = Info.new
    s = InfoDisplayWindow.new(model.name, model.title)
    s.display(model.formatter)
  end
end

