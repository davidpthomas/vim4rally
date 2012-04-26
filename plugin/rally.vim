
" Rally Integration for Vim
"
" This script bootstraps the integration and only loads the Rally plugin
" libraries if a connection to Rally is successful.
"
" Last Changed: Sat Jul 30 13:39:29 PDT 2011
" Maintainer: David P Thomas <dthomas@rallydev.com>, <davidpthomas@gmail.com>
" URL: www.rallydev.com, www.davidpthomas.name

" Prevent re-loading
if exists("g:rally_vars['loaded_plugin']") | finish | endif

" Require Vim 7.0+; due to FuncRefs and Dict usage
if v:version < 700 | echomsg "Rally: Plugin requires Vim 7.0+" | finish | endif
" Requires Ruby option compiled into Vim
if !has('ruby') | echomsg "Rally: Plugin requires ruby support compiled in Vim.  Look for +ruby in '$vim --version'." | finish | endif

" common vars
let g:true = 1
let g:false = 0
let g:notfound = -1
let g:empty = ""

" storage for plugin settings
let g:rally_vars = {}

" user-defined plugin keybindings
" *** BE SURE TO UPDATE DOCUMENTATION AT doc/rally.vim WITH ANY CHANGES
let g:rally_vars["keys"] = {}
let g:rally_vars["keys"]["rally"] = "r"
let g:rally_vars["keys"]["info"] = "z"
let g:rally_vars["keys"]["quickhelp"] = "h"
let g:rally_vars["keys"]["choose_workspace"] = "w"
let g:rally_vars["keys"]["choose_iteration"] = "i"
let g:rally_vars["keys"]["search"] = "s"
let g:rally_vars["keys"]["update_task_todo"] = "tt"
let g:rally_vars["keys"]["update_task_estimate"] = "te"
let g:rally_vars["keys"]["update_task_toggle_blocked"] = "tb"
let g:rally_vars["keys"]["chart_iteration_burndown"] = "cb"
let g:rally_vars["keys"]["chart_iteration_cumulative_flow"] = "cc"

" Descriptions used in quick help
let g:rally_vars["descriptions"] = {}
let g:rally_vars["descriptions"]["rally"] = "r"
let g:rally_vars["descriptions"]["info"] = "Show connection information"
let g:rally_vars["descriptions"]["quickhelp"] = "Show list of commands"
let g:rally_vars["descriptions"]["choose_workspace"] = "Switch Rally workspace"
let g:rally_vars["descriptions"]["choose_iteration"] = "Switch Rally iteration"
let g:rally_vars["descriptions"]["search"] = "Search"
let g:rally_vars["descriptions"]["update_task_todo"] = "Update task to do"
let g:rally_vars["descriptions"]["update_task_estimate"] = "Update task estimate"
let g:rally_vars["descriptions"]["update_task_toggle_blocked"] = "Toggle task block"
let g:rally_vars["descriptions"]["chart_iteration_burndown"] = "Chart: Iteration Burndown"
let g:rally_vars["descriptions"]["chart_iteration_cumulative_flow"] = "Chart: Iteration Cumulative Flow"

" system info
let g:rally_vars["plugin_version"] = "1.0"
let g:rally_vars["plugin_date"] = "2012.04.26"
let g:rally_vars["plugin_release"] = g:rally_vars["plugin_version"] . " " . g:rally_vars["plugin_date"]
let g:rally_vars["lib_dir"] = expand("<sfile>:h") . "/lib"   " plugin lib folder; must set in vim since ruby code is dyn loaded
let g:rally_vars["property_file"] = expand("<sfile>:h") . "/rally.properties"   " plugin property file; must set in vim since ruby code is dyn loaded
let g:rally_vars["loaded_plugin"] = g:true      " used to prevent re-loading and auto-sourcing the main lib/rally.vim file
let g:rally_vars["loaded_workspace"] = g:false  " used to prevent re-loading and auto-sourcing the main lib/rally.vim file

" Rally info
let g:rally_vars["workspace_name"] = ''
let g:rally_vars["iteration_name"] = 'None'

" Enable line continuation w/o disrupting compatibility mode
let s:save_cpo = &cpo
set cpo&vim

" Warn users if their password is not protected
if match(getfperm(g:rally_vars["property_file"]), "rw-------") < 0
  echo "**[ !! Warning !! ]**********************************************"
  echo "Rally property file contains your Rally password.  Prevent access"
  echo "to other users by setting file permissions to 600 or 'rw-------'."
  echo "FILE: [" . g:rally_vars["property_file"] . "]"
  echo "*****************************************************************"
endif

" Attept to connect to Rally.
" If unsuccessful, do not load the plugin
try

ruby << GOTRUBY

  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # Pre-register ALL ruby files to be loaded on-demand
  #   convention: underscore filename => camelized module
  #      example: update_task_todo_controller.rb --> :UpdateTaskTodoController
  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  rbfiles = File.join(VIM::evaluate("g:rally_vars['lib_dir']"), "ruby", "**", "*.rb")
  Dir.glob(rbfiles).each do |filename_abs|
    filename_noext = File.basename(filename_abs).gsub!(/\.rb$/, '')  # portion of filename to camelize
    modname = filename_noext.gsub(/(^|_)(.)/) {$2.upcase}  # camelize filename
    autoload(modname, filename_abs)
  end

  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # IMPORTANT - GLOBAL VARIABLE '$conn' used **everwhere** implicitly in ruby code
  #           - $conn is a wrapper for cached workspace info and the live rally connection
  #           - I hate globals but this cleaned up a TON of code
  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  $conn = ConnectionController.new.conn

GOTRUBY

  " vim key mappings and plugin routines; only loaded if connection above successful
  runtime plugin/rally/lib/vim/rally_bindings.vim

catch /RallyPropertiesError/
  echo "Error loading Rally properties.  Check " . g:rally_vars["property_file"]
  unlet g:rally_vars["loaded_plugin"]
catch /RallyUsernameRequired/
  echo "Rally username required (See rally.vim) - Rally plugin not loaded."
  unlet g:rally_vars["loaded_plugin"]
catch /RallyPasswordRequired/
  echo "Rally password required (See rally.vim) - Rally plugin not loaded."
  unlet g:rally_vars["loaded_plugin"]
catch /RallyBaseUrlRequired/
  echo "Rally base url required (See rally.vim) - Rally plugin not loaded."
  unlet g:rally_vars["loaded_plugin"]
catch /RallyVersionRequired/
  echo "Rally version required (See rally.vim) - Rally plugin not loaded."
  unlet g:rally_vars["loaded_plugin"]
catch /RallyConnectError/
  echo "Unable to connect to Rally.  Check network connection."
  unlet g:rally_vars["loaded_plugin"]
catch /RallyWorkspaceNotFound/
  echo "Workspace not found.  Check rally.properties file."
  unlet g:rally_vars["loaded_plugin"]
catch /.*/
  echo "Error loading plugin. Caught" . v:exception . " in " . v:throwpoint
  unlet g:rally_vars["loaded_plugin"]
endtry

let &cpo = s:save_cpo " restore environment after script has been loaded.

finish " you win!
