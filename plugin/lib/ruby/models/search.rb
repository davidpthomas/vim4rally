# Class for managing search criteria and results.  Instances need
# to be created as the search strategy is determined based on the
# current environment (e.g. current line) or user input.
class Search

  extend Forwardable
  def_delegators :@strategy, :query, :results, :has_results?, :name, :title, :formatter

  def initialize(reload = false)
    @reload = reload
    @strategy = find_strategy
  end

  private

  # Primary algorithm for determining what is being searched, either
  # from data in the current vim environment, or from user input.
  def find_strategy

    strategy = nil
 
    search_context = ""


    # reload use already loaded artifact
    if @reload && VIM::evaluate("exists(\"b:rally_vars['formatted_id']\")") == 1
      search_context = VIM::evaluate("b:rally_vars['formatted_id']")
    # look on current line
    elsif search_context.empty?
      search_context = VIM::evaluate("getline('.')")
    # look in visual search
    elsif
      begin 
        search_context = VIM::evaluate("getreg('*')")
        VIM::evaluate("setreg('*', '')") if !search_context.empty?
      rescue
        # Ignore error; only for vim that doesn't have +clipboard option compiled in
      end
    end

    begin

      search_token = search_context

      if search_token.empty?
        # TODO: loop and provide user feedback on bad input
        search_token = VIM::evaluate('input("Rally Search: ")')
      end

      strategy = SearchStrategyFactory.find(search_token)
    rescue Exception => e
      # swallow; just return nil strategy below
    end
    return strategy
  end

end

# Factory class for identifying which search strategy (User Story, Defect, etc)
# to use for performing the actual search.
class SearchStrategyFactory
  def self.find(search_token)
    strategy = nil

    # upcase everything to allow lazy search by formatted id (e.g. 'ta78' will find & load 'TA78')
    prefix_userstory = $conn.workspace.prefix_userstory.upcase
    prefix_task = $conn.workspace.prefix_task.upcase
    prefix_defect = $conn.workspace.prefix_defect.upcase

    # extract formatted id from full string e.g. "foo S123 bar" -> "S123"
    if (match = search_token.upcase.match(/(#{prefix_userstory}|#{prefix_task}|#{prefix_defect})(\d+)/))   # /(S|DE|TA)\d+/
      prefix = match[1].upcase
      numeric_id = match[2]

      case prefix
      when "#{prefix_userstory}"
        strategy = UserStorySearchByIdStrategy.new(numeric_id)
      when "#{prefix_task}"
        strategy = TaskSearchByIdStrategy.new(numeric_id)
      when "#{prefix_defect}"
        strategy = DefectSearchByIdStrategy.new(numeric_id)
      else
        # TODO: handle error
      end
    # search text e.g. "Purchase Your Items"
    else
      strategy = SearchByText.new(search_token)
    end

  end
end

# User story search.
class UserStorySearchByIdStrategy

  attr_accessor :results

  def initialize(numeric_id)
    @numeric_id = numeric_id
  end

  def query
    @results = UserStory.find_by_id(@numeric_id)
  end

  def has_results?
    (@results.nil?) ? false : true
  end

  def name
    @results.formatted_i_d
  end

  def title
    "Story #{@results.formatted_i_d}: \"#{@results.name}\""
  end

  def formatter
    (@results.nil?) ? nil : UserStorySingleFormatter.new(@results) 
  end
end

# Task search.
class TaskSearchByIdStrategy

  attr_accessor :results

  def initialize(numeric_id)
    @numeric_id = numeric_id
  end

  def query
    @results = Task.find_by_id(@numeric_id)
  end

  def has_results?
    (@results.nil?) ? false : true
  end

  def name
    @results.formatted_i_d
  end

  def title
    "Task #{@results.formatted_i_d}: \"#{@results.name}\""
  end

  def formatter
    (@results.nil?) ? nil : TaskSingleFormatter.new(@results) 
  end
end

# Defect search.
class DefectSearchByIdStrategy

  attr_accessor :results

  def initialize(numeric_id)
    @numeric_id = numeric_id
  end

  def query
    @results = Defect.find_by_id(@numeric_id)
  end

  def has_results?
    (@results.nil?) ? false : true
  end

  def name
    @results.formatted_i_d
  end

  def title
    "Defect #{@results.formatted_i_d}: \"#{@results.name}\""
  end

  def formatter
    (@results.nil?) ? nil : DefectSingleFormatter.new(@results) 
  end
end


# General text search
class SearchByText
  attr_accessor :results

  def initialize(search_text)
    @search_text = search_text
  end

  def query
    @results = Artifact.find_by_text(@search_text)
  end

  def has_results?
    (@results.nil?) ? false : true
  end

  def name
    "text-search"
  end

  def title
    "Text Search: Found #{@results.size} matches."
  end

  def formatter
    (@results.nil?) ? nil : MultipleResultsFormatter.new(@results)
  end
end

