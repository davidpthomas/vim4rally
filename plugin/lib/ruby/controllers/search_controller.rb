class SearchController < RallyController

  def initialize(reload = false)
    @reload = reload      # flag to attempt reload an existing artifact already loaded
    super()
  end

  def execute
    search = Search.new(@reload)

    begin
      search.query
    rescue RallyObjectNotFound => e
      VIM::message(e.message)
    end

    if search.has_results?
      s = SearchDisplayWindow.new(search.name, search.title)
      s.display(search.formatter)
    end
  end
end
