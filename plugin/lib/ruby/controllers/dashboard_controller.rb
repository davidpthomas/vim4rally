class DashboardController < RallyController

  def initialize
    super()
  end

  def execute

    curr_tab_id = VIM::evaluate("tabpagenr()")

    dashboard_exists = false

    for tab_id in 1..VIM::evaluate("tabpagenr('$')")
      if VIM::evaluate("gettabvar(#{tab_id}, 'name')") == "dashboard"
        if curr_tab_id != tab_id
          VIM::evaluate("settabvar(#{tab_id}, 'lastfile_tab_id', #{curr_tab_id})")
        end
        dashboard_tab_id = tab_id
        dashboard_exists = true
        break
      end
    end

    if dashboard_exists
      if curr_tab_id == dashboard_tab_id
        lastfile_tab_id = VIM::evaluate("gettabvar(#{dashboard_tab_id}, 'lastfile_tab_id')")
        VIM::command("tabnext #{lastfile_tab_id}")
      else
        VIM::command("tabnext #{dashboard_tab_id}")
      end
      return
    end

    # model: panels/queries
    begin
      VIM::command("set syntax=rally")
      VIM::command("tabnew 'My Dashboard'")

      dashboard_tab_id = VIM::evaluate("tabpagenr()")
      VIM::evaluate("settabvar(#{dashboard_tab_id}, 'lastfile_tab_id', #{curr_tab_id})")
      VIM::evaluate("settabvar(#{dashboard_tab_id}, 'name', 'dashboard')")
      VIM::command("set showtabline=1")

      progress = ProgressBar.new("Loading My Dashboard...", 6)
      progress.increment

      line_cnt = 0
      # my stuff
      content = Artifact.find_blocked_by_owner("paul@acme.com")
      VIM::Buffer.current.append(line_cnt, "Blocked")
      # fill buffer with content
      content.each do |artifact|
        line_cnt += 1
        line = artifact.formatted_i_d + " " + artifact.name + " " + artifact.blocked
        VIM::Buffer.current.append(line_cnt, line)
      end

      VIM::Buffer.current.append(line_cnt, "")
      line_cnt += 1

      progress.increment

      content = Task.find_by_owner("paul@acme.com")
      VIM::Buffer.current.append(line_cnt, "My Tasks")
      # fill buffer with content
      content.each do |task|
        line_cnt += 1
        line = task.formatted_i_d + " " + task.name
        VIM::Buffer.current.append(line_cnt, line)
      end
      VIM::Buffer.current.append(line_cnt, "")
      line_cnt += 1

      progress.increment
      content = Defect.find_by_owner("paul@acme.com")
      VIM::Buffer.current.append(line_cnt, "My Defects")
      # fill buffer with content
      content.each do |task|
        line_cnt += 1
        line = task.formatted_i_d + " " + task.name
        VIM::Buffer.current.append(line_cnt, line)
      end
      VIM::Buffer.current.append(line_cnt, "")
      line_cnt += 1

      progress.increment

    ensure
      progress.close
    end

    # NOTIFICATIONS
    begin
      VIM::command("vert new 'My Notifications'")
      VIM::command("setlocal laststatus=0")
      progress = ProgressBar.new("Loading Notifications...", 3)
      progress.increment

    ensure
      progress.close
    end

    # DISCUSSIONS
    begin
      VIM::command("aboveleft new 'My Discussions'")
      VIM::command("setlocal laststatus=0")
      progress = ProgressBar.new("Loading Discussions...", 3)
      progress.increment
    ensure
      progress.close
    end

    VIM::command("setlocal laststatus=2")

  end
end

