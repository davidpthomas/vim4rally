vim4rally
=========

Rally ALM Integration for Vim.

Installation
------------
See <a href="https://github.com/davidpthomas/vim4rally/blob/master/doc/rally.txt">doc/rally.txt</a> for Requirements & Installation details.

This plugin is not a simple vimscript.  It requires vim compiled with Ruby and needs the Rally ruby gem (among other things).
Installation also assumes you use <a href="https://github.com/gmarik/vundle">vundle</a> plugin manager.

This plugin is currently tested using vim 7.4 and ruby 2.0.

As for Vim, this plugin was initially developed on Vim 7.2p374.  That is the minimal patch version of vim known to work with this plugin due to a patch (for ruby eval()).
As for Ruby, prior versions of this plugin have been compatible with ruby 1.8.x, 1.9.x.  

Given how much time has gone by and dependencies on vim versions, ruby versions, rubygem versions, etc.
I can only guarantee that the latest plugin works with vim 7.4, ruby 2.0, and rally rest API gem 1.1.0.
There's nothing particularly version specific about the plugin or ruby code so you may have good luck
with older versions of things.  If your env prevents having the latest versions of things, I'd suggest
using RVM to create a safe/clean ruby/gem env to test things out with a local checkout of vim source.

Screenshots
-----------
Below are some screenshots that say it all :)

<table>
<tr>
<td><a href="https://github.com/davidpthomas/vim4rally/blob/master/doc/screenshots/vim4rally_inlinehelp.png"><img width="400" src="https://github.com/davidpthomas/vim4rally/raw/master/doc/screenshots/vim4rally_inlinehelp.png" border="0"></a></td>
<td><a href="https://github.com/davidpthomas/vim4rally/blob/master/doc/screenshots/vim4rally_storydetails.png"><img width="400" src="https://github.com/davidpthomas/vim4rally/raw/master/doc/screenshots/vim4rally_storydetails.png" border="0"></a></td>
</tr>
<tr>
<td><div style="text-align:center;width: 100%"><b>Inline Help</b></div></td>
<td><div style="text-align:center;width: 100%"><b>Story Details</b></div></td>
</tr>

<tr>
<td><a href="https://github.com/davidpthomas/vim4rally/blob/master/doc/screenshots/vim4rally_updatetask.png"><img width="400" src="https://github.com/davidpthomas/vim4rally/raw/master/doc/screenshots/vim4rally_updatetask.png" border="0"></a></td>
<td><a href="https://github.com/davidpthomas/vim4rally/blob/master/doc/screenshots/vim4rally_burndown.png"><img width="400" src="https://github.com/davidpthomas/vim4rally/raw/master/doc/screenshots/vim4rally_burndown.png" border="0"></a></td>
</tr>
<tr>
<td><div style="text-align:center;width: 100%"><b>Updating Tasks</b></div></td>
<td><div style="text-align:center;width: 100%"><b>Iteration Burndown Chart</b></div></td>
</tr>

<tr>
<td><a href="https://github.com/davidpthomas/vim4rally/blob/master/doc/screenshots/vim4rally_cumulativeflow.png"><img width="400" src="https://github.com/davidpthomas/vim4rally/raw/master/doc/screenshots/vim4rally_cumulativeflow.png" border="0"></a></td>
<td><a href="https://github.com/davidpthomas/vim4rally/blob/master/doc/screenshots/vim4rally_helpdoc.png"><img width="400" src="https://github.com/davidpthomas/vim4rally/raw/master/doc/screenshots/vim4rally_helpdoc.png" border="0"></a></td>
</tr>
<tr>
<td><div style="text-align:center;width: 100%"><b>Iteration Cumulative Flow</b></div></td>
<td><div style="text-align:center;width: 100%"><b>Rally Help</b></div></td>
</tr>


</table>
