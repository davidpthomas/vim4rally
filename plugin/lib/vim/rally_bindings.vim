" Rally Integration for Vim - Main Library
"
" Last Changed: Thu Oct 13 07:23:53 PDT 2011
" Maintainer: David P Thomas <dthomas@rallydev.com>, <davidpthomas@gmail.com>
" URL: www.rallydev.com, www.davidpthomas.name

" This file cannot and will not be loaded unless the bootstrap 'rally.vim' is loaded first.
if !exists("g:rally_vars['loaded_plugin']") | finish | endif

" Section: User Customization {{{1

" set the first key for all mappings aka. <Leader>
let s:mapleader = '\'

" }}}

" Section: Initialization {{{1

" Function: LateStrapRally {{{2
" Allow late loading of Rally resources since they are expensive
" to load on Vim/plugin startup.
function! s:LateStrapRally(functionName, mode)

  " empty implicit any stored visual matches if searching from normal mode
  " - otherwise it confuses the search strategy lookup that attempts to check
  "   visual search first
  if a:mode == "normal"
    try
    call setreg('*', '')
    catch
        " Ignore error; only for vim that doesn't have +clipboard option compiled in
    endtry
  endif

  if g:rally_vars["loaded_workspace"] == g:false
    try
ruby << GOTRUBY
       LoadWorkspaceController.new
GOTRUBY
      let g:rally_vars['loaded_workspace'] = g:true
    " specified default workspace in prop file not found; must abort as workspace is required
    catch /RallyWorkspaceNotFound/
      redraw
      echo "Rally workspace not found. Check " . g:rally_vars["property_file"]
      return
    endtry
  end

  " workspace successfully loaded; add rally info to statusline
  call s:SetStatusLine()

  let l:FnRef = function(a:functionName)   " pointer to function of given name
  call l:FnRef()                           " execute the function
endfunction "}}}

" Function: SetStatusLine {{{2
" Sets the global statusline to include rally information
function! s:SetStatusLine()
  if !exists("g:rally_vars['loaded_statusline']")
    " enable status bar and augment current by appending workspace name, right justified
    set laststatus=2
    set statusline=%t\ [%p%%-%l-%c]%=%m%r[%{g:rally_vars['iteration_name']}][%{g:rally_vars['workspace_name']}]
    let g:rally_vars["loaded_statusline"] = g:true
  endif
endfunction "}}}

" }}}

" Section: Key Mappings {{{1

" NOTE: keys are defined in vars for displaying them throughout
"       the plugin as well as registering them here
" NOTE: Be sure to update menus if mapping calls below change; menus use the same calls

let s:keys = g:rally_vars["keys"]  " storage for defined key; set in first file


" FIXME need to build/finish support for dashboards
"if !hasmapto('<Plug>Rally')
"  execute("nmap <Leader>" . s:keys["rally"] . " <Plug>Rally")
"  nnoremap <script> <Plug>Rally <SID>Rally
"endif
"nnoremap <silent> <SID>Rally :call <SID>LateStrapRally("s:Dashboard", "normal")<CR>

if !hasmapto('<Plug>RallyInfo')
  execute("nmap <Leader>" . s:keys["info"] . " <Plug>RallyInfo")
  nnoremap <script> <Plug>RallyInfo <SID>Info
endif
nnoremap <silent> <SID>Info :call <SID>LateStrapRally("s:Info", "normal")<CR>

if !hasmapto('<Plug>RallyQuickHelp')
  execute("nmap <Leader>" . s:keys["quickhelp"] . " <Plug>RallyQuickHelp")
  nnoremap <script> <Plug>RallyQuickHelp <SID>QuickHelp
endif
nnoremap <silent> <SID>QuickHelp :call <SID>QuickHelp()<CR>

" FIXME - need to build support for choosing iterations
"if !hasmapto('<Plug>RallyChooseIteration')
" execute("nmap <Leader>" . s:keys["choose_iteration"]. " <Plug>RallyChooseIteration")
" nnoremap <script> <Plug>RallyChooseIteration <SID>ChooseIteration
"ndif
"noremap <silent> <SID>ChooseIteration :call <SID>ChooseIteration()<CR>

if !hasmapto('<Plug>RallyChooseWorkspace')
  execute("nmap <Leader>" . s:keys["choose_workspace"]. " <Plug>RallyChooseWorkspace")
  nnoremap <script> <Plug>RallyChooseWorkspace <SID>ChooseWorkspace
endif
nnoremap <silent> <SID>ChooseWorkspace :call <SID>ChooseWorkspace()<CR>

if !hasmapto('<Plug>RallySearch')
  execute("nmap <Leader>" . s:keys["search"] . " <Plug>RallySearch")
  nnoremap <script> <Plug>RallySearch <SID>Search
  execute("vmap <Leader>" . s:keys["search"] . " <Plug>RallySearch")
  vnoremap <script> <Plug>RallySearch <SID>Search
endif
nnoremap <silent> <SID>Search :call <SID>LateStrapRally("s:Search", "normal")<CR>
vnoremap <silent> <SID>Search :call <SID>LateStrapRally("s:Search", "visual")<CR>

if !hasmapto('<Plug>RallyUpdateTaskTodo')
  execute("nmap <Leader>" . s:keys["update_task_todo"] . " <Plug>RallyUpdateTaskTodo")
  nnoremap <script> <Plug>RallyUpdateTaskTodo <SID>UpdateTaskTodo
endif
nnoremap <silent> <SID>UpdateTaskTodo :call <SID>LateStrapRally("s:UpdateTaskTodo", "normal")<CR>

if !hasmapto('<Plug>RallyUpdateTaskEstimate')
  execute("nmap <Leader>" . s:keys["update_task_estimate"] . " <Plug>RallyUpdateTaskEstimate")
  nnoremap <script> <Plug>RallyUpdateTaskEstimate <SID>UpdateTaskEstimate
endif
nnoremap <silent> <SID>UpdateTaskEstimate :call <SID>LateStrapRally("s:UpdateTaskEstimate", "normal")<CR>

if !hasmapto('<Plug>RallyUpdateTaskToggleBlocked')
  execute("nmap <Leader>" . s:keys["update_task_toggle_blocked"] . " <Plug>RallyUpdateTaskToggleBlocked")
  nnoremap <script> <Plug>RallyUpdateTaskToggleBlocked <SID>UpdateTaskToggleBlocked
endif
nnoremap <silent> <SID>UpdateTaskToggleBlocked :call <SID>LateStrapRally("s:UpdateTaskToggleBlocked", "normal")<CR>

if !hasmapto('<Plug>RallyIterationBurndown')
  execute("nmap <Leader>" . s:keys["chart_iteration_burndown"] . " <Plug>RallyIterationBurndown")
  nnoremap <script> <Plug>RallyIterationBurndown <SID>IterationBurndown
endif
nnoremap <silent> <SID>IterationBurndown :call <SID>LateStrapRally("s:IterationBurndown", "normal")<CR>

if !hasmapto('<Plug>RallyIterationCumulativeFlow')
  execute("nmap <Leader>" . s:keys["chart_iteration_cumulative_flow"] . " <Plug>RallyIterationCumulativeFlow")
  nnoremap <script> <Plug>RallyIterationCumulativeFlow <SID>IterationCumulativeFlow
endif
nnoremap <silent> <SID>IterationCumulativeFlow :call <SID>LateStrapRally("s:IterationCumulativeFlow", "normal")<CR>

" }}}

" Section: Console and GUI Menus {{{1

" Enable console menu
source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

" Custom Rally menus
menu <script> <silent> 500.10 &Rally.&Search :call <SID>LateStrapRally("s:Search", "normal")<CR>
menu <script> <silent> 500.20 &Rally.&Dashboard :call <SID>LateStrapRally("s:Dashboard", "normal")<CR>
menu <script> <silent> 500.30.10 &Rally.&Update.&Task\ To\ Do :call <SID>LateStrapRally("s:UpdateTaskTodo", "normal")<CR>
menu <script> <silent> 500.30.10 &Rally.&Update.&Task\ Estimate :call <SID>LateStrapRally("s:UpdateTaskEstimate", "normal")<CR>
menu <script> <silent> 500.30.10 &Rally.&Update.&Task\ Toggle\ Block :call <SID>LateStrapRally("s:UpdateTaskToggleBlock", "normal")<CR>
menu <script> <silent> 500.40.10 &Rally.&Charts.&Iteration\ Burndown :call <SID>LateStrapRally("s:IterationBurndown", "normal")<CR>
menu <script> <silent> 500.50.10 &Rally.&Charts.&Iteration\ Cumulative\ Flow :call <SID>LateStrapRally("s:IterationCumulativeFlow", "normal")<CR>
menu 500.45 Rally.-Separator- :
menu <script> <silent> 500.90.10 &Rally.&Setup.&Choose\ Iteration :call <SID>Choose()<CR>
menu <script> <silent> 500.90.10 &Rally.&Setup.&Choose\ Workspace :call <SID>ChooseWorkspace()<CR>
menu 500.95 Rally.-Separator- :
menu <script> <silent> 500.100.10 &Rally.&Help.&Commands :call <SID>QuickHelp()<CR>
menu <script> <silent> 500.100.20 &Rally.&Help.&Info :call <SID>LateStrapRally("s:Info", "normal")<CR>

" }}}

" Section: Plugin Functions (Business Controller) {{{1

" Function: Search {{{2
" Description: Displays story details in separate buffer/window
function! s:Search()
ruby << GOTRUBY
  SearchController.new
GOTRUBY
endfunction " }}}

" Function: UpdateTaskTodo {{{2
" Description: Prompt user to update task todo
function! s:UpdateTaskTodo()
ruby << GOTRUBY
  UpdateTaskTodoController.new
GOTRUBY
endfunction " }}}

" Function: UpdateTaskEstimate {{{2
" Description: Prompt user to update task estimate
function! s:UpdateTaskEstimate()
ruby << GOTRUBY
  UpdateTaskEstimateController.new
GOTRUBY
endfunction " }}}

" Function: UpdateTaskToggleBlocked {{{2
" Description: Prompt user to toggle blocked
function! s:UpdateTaskToggleBlocked()
ruby << GOTRUBY
  UpdateTaskToggleBlockedController.new
GOTRUBY
endfunction " }}}

" Function: Iteration Burndown {{{2
" Description: Display Iteration Burndown
function! s:IterationBurndown()
  tabnew 'IterationBurndown'
  if has('syntax') | setlocal syntax=rally | endif
ruby << GOTRUBY
  IterationBurndownController.new
GOTRUBY

autocmd VimResized * :call s:IterationBurndownRedraw()
endfunction " }}}

" Utility to redraw the burndown without creating a new tab {{{2
function! s:IterationBurndownRedraw()
ruby << GOTRUBY
  IterationBurndownController.new
GOTRUBY
endfunction " }}}

" Function: Iteration CumulativeFlow {{{2
" Description: Display Iteration CumulativeFlow
function! s:IterationCumulativeFlow()
  tabnew 'IterationCumulativeFlow'
  if has('syntax') | setlocal syntax=rally | endif
ruby << GOTRUBY
  IterationCumulativeFlowController.new
GOTRUBY

autocmd VimResized * :call s:IterationCumulativeFlowRedraw()
endfunction " }}}

" Utility to redraw the burndown without creating a new tab
function! s:IterationCumulativeFlowRedraw()
ruby << GOTRUBY
  IterationCumulativeFlowController.new
GOTRUBY
endfunction " }}}

" Function: ChooseIteration {{{2
" Description: Prompts user to select a specific rally iteration
function! s:ChooseIteration()

  try
ruby << GOTRUBY
  ChooseIterationController.new
GOTRUBY
  " user cancels selection of workspace; must abort as workspace is required
  catch /RallyNoSelection/
    redraw
    echo "No Rally iteration selected."
  endtry

  " may need to set statusline if choosing workspace is first thing someone ever does
  " note: redundant with funnel through LateStrap but this is an 'exception' route
  "       if a workspace is not set in the prop file
  call s:SetStatusLine()

endfunction " }}}

" Function: ChooseWorkspace {{{2
" Description: Prompts user to select a specific rally workspace
function! s:ChooseWorkspace()

  try
ruby << GOTRUBY
  ChooseWorkspaceController.new
GOTRUBY
  " user cancels selection of workspace; must abort as workspace is required
  catch /RallyNoSelection/
    redraw
    echo "No Rally workspace selected."
  endtry

  " may need to set statusline if choosing workspace is first thing someone ever does
  " note: redundant with funnel through LateStrap but this is an 'exception' route
  "       if a workspace is not set in the prop file
  call s:SetStatusLine()

endfunction " }}}

" Function: Info {{{2
" Description: Displays info about rally plugin and connection
function! s:Info()
ruby << GOTRUBY
  InfoController.new
GOTRUBY
endfunction " }}}

" Function: QuickHelp {{{2
" Description: Displays 'quickhelp' info with key commands
function! s:QuickHelp()
ruby << GOTRUBY
  QuickHelpController.new
GOTRUBY
endfunction " }}}

" Function: Dashboard {{{2
" Description: Displays a personal dashboard of Rally info
function! s:Dashboard()
ruby << GOTRUBY
  DashboardController.new
GOTRUBY
endfunction " }}}

" }}}

finish " you win!
