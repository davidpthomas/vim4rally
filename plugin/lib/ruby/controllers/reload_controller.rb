class ReloadController < RallyController

  def initialize(ref)
    @ref = ref   # set before super(); that invokes execute internally
    super()
  end

  private

  # only perform a reload if in details page for the current artifact
  def execute
    expected_formatted_id = @ref.formatted_i_d

    # search active windows for current buffer containing artifact details (by formatted id)
    # if found, perform a new search to update the display data
    last_win_id = VIM::evaluate("winnr('$')")
    for win_id in 0..last_win_id
        buf_id = VIM::evaluate("winbufnr(#{win_id})")
        rally_vars = VIM::evaluate("getbufvar(#{buf_id}, 'rally_vars')")
        # not all windows will have search results
        if rally_vars.respond_to?("has_key?") && rally_vars.has_key?("formatted_id")
          SearchController.new(true) if rally_vars["formatted_id"] == expected_formatted_id
        end
    end
  end
end
