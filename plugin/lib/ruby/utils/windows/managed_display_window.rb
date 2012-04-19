class ManagedDisplayWindow

  # win_name => buf_name => buf_attrs
  # e.g.    { 'search' => { :window_id => 4,
  #                       { "multi-results" => {:title => 'Keyword Search', :buf_id => 5},
  #                       { "US123" => {:title => 'US123 Purchase Items', :buf_id => 3},

  @@window_buffers = {}

  # TODO: pass in type of window (e.g. botright) as enum (?)
  def initialize(window_name, buffer_name, buffer_title)

    window_active = false
    # check if window still exists searching for window with matching name
    last_win_id = VIM::evaluate("winnr('$')")
    for win_id in 0..last_win_id
      v = VIM::evaluate("getwinvar(#{win_id}, 'rally_window_name')")
      window_active = true if v == window_name
    end

    # cleanup our cache if window was closed by user
    @@window_buffers.delete(window_name) if !window_active

    # window existed and is active
    if @@window_buffers.has_key?(window_name) && window_active
      # buffer does not exist yet
      if !@@window_buffers[window_name].has_key?(buffer_name)

        # move to window
        window_id = @@window_buffers[window_name][:window_id]
        VIM::command("#{window_id}wincmd w")

        # create new buffer
        VIM::command("edit! #{buffer_name}")
        buffer_id = VIM::evaluate("bufnr('#{buffer_name}')")
        buffer_attrs = { :name => buffer_name,
                         :title => buffer_title,
                         :buffer_id => buffer_id }

        # cache buffer for lookup
        @@window_buffers[window_name][buffer_name] = buffer_attrs

        # set local attrs on vim buffer
        set_buffer_attrs(buffer_name)

      # buffer exists; lets re-use the buffer but empty contents and reload (downstream)
      else
        # TODO: toggle back an existing buffer e.g. multi search results
        window_id = @@window_buffers[window_name][:window_id]

        VIM::command("#{window_id}wincmd w")    # move to window
        VIM::command("buffer #{buffer_name}")   # load existing buffer
        VIM::command("%d")                      # delete contents
      end

    # window does not exist
    else
      # create new window & buffer
      VIM::command("silent botright new #{buffer_name}")
      VIM::command("let w:rally_window_name = '#{window_name}'")  # set name for future lookup

      buffer_id = VIM::evaluate("bufnr('%')")
      window_id = VIM::evaluate("bufwinnr(#{buffer_id})")

      buffer_attrs = {:name => buffer_name,
                      :title => buffer_title,
                      :buffer_id => buffer_id}

      # cache window & buffer for lookup
      @@window_buffers[window_name] = {}      # props for new window
      @@window_buffers[window_name][:window_id] = window_id
      @@window_buffers[window_name][buffer_name] = buffer_attrs

      # set local attrs on vim buffer
      set_buffer_attrs(buffer_name)
    end

    # always show status line
    status_title_escaped = buffer_title.gsub(/\ /, '\\ ').gsub(/"/, '\\"')   # escape spaces for vim statusline format
    quickhelp_key = $conn.vars["keys"]["quickhelp"]
    VIM::command("setlocal laststatus=2")
    VIM::command("setlocal statusline=%<" + status_title_escaped + "%=[\\\\" + quickhelp_key + "\\ Rally\\ Help]")
  end

  # Override
  def display(results_formatter)
  end

  def self.window_buffers
    @@window_buffers
  end

  def self.to_s
    @@window_buffers.inspect
  end

  private

  def set_buffer_attrs(buffer_name)
      # set internal attrs on buffer in window
      VIM::command("let b:rally_vars = {}")
      VIM::command("let b:rally_vars['buffer_name'] = '#{buffer_name}'")  # for lookup
  end
end
