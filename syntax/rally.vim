" Vim syntax file for Rally
"
" Maintainer:   David P Thomas, <davidpthomas@gmail.com>
" Last Changed: Sun Jul 31 00:22:24 PDT 2011
"
if !exists("main_syntax")
  if version < 700
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax='rally'
endif

"====================================================
"
" ********************
" Story
" ********************
syntax match rallyStoryFields / \(ID \|Name\|Tags \|Owner \|Project \|Description \|Parent \|Work\ Product \)/
highlight rallyStoryFields term=bold cterm=bold gui=bold ctermfg=Yellow ctermbg=NONE guifg=Yellow guibg=NONE

syntax match rallyFieldsSeparator /\(|\ \|--\|__|\|___\||__\)/
highlight rallyFieldsSeparator term=NONE cterm=NONE gui=NONE ctermfg=White ctermbg=NONE guifg=White guibg=NONE

syntax match rallyStoryBlocked /BLOCKED/
highlight rallyStoryBlocked term=bold cterm=bold gui=bold ctermfg=White ctermbg=Red guifg=White guibg=Red

syntax match rallyStorySchedule /\(Story State\|Iteration\|Release\|State\|Schedule\ State\|Plan\ Estimate\|Task\ Estimate\ Total\|Task\ Remaining\ Total\) |/
highlight rallyStorySchedule term=bold cterm=bold gui=bold ctermfg=White ctermbg=NONE guifg=White guibg=None

syntax match rallyStoryUnscheduled /Unscheduled/
highlight rallyStoryUnscheduled term=NONE cterm=NONE gui=NONE ctermfg=Blue ctermbg=NONE guifg=Blue guibg=None

syntax match rallyStoryChildren /US\d\+:/
highlight rallyStoryChildren term=NONE cterm=NONE gui=NONE ctermfg=Yellow ctermbg=NONE guifg=Yellow guibg=None

syntax match rallyStoryEpic /Epic:/
highlight rallyStoryEpic term=NONE cterm=NONE gui=NONE ctermfg=White ctermbg=Blue guifg=Black guibg=White

syntax match rallyStoryScheduleStateBacklog /\[B\]/
highlight rallyStoryScheduleStateBacklog term=NONE cterm=NONE gui=NONE ctermfg=DarkCyan ctermbg=NONE guifg=Black guibg=NONE

syntax match rallyStoryScheduleStateDefined /\[D\]/
highlight rallyStoryScheduleStateDefined term=NONE cterm=NONE gui=NONE ctermfg=DarkBlue ctermbg=NONE guifg=Black guibg=NONE

syntax match rallyStoryScheduleStateInProgress /\[P\]/
highlight rallyStoryScheduleStateInProgress term=NONE cterm=NONE gui=NONE ctermfg=Blue ctermbg=NONE guifg=Black guibg=NONE

syntax match rallyStoryScheduleStateCompleted /\[C\]/
highlight rallyStoryScheduleStateCompleted term=NONE cterm=NONE gui=NONE ctermfg=White ctermbg=NONE guifg=Black guibg=NONE

syntax match rallyStoryScheduleStateAccepted /\[A\]/
highlight rallyStoryScheduleStateAccepted term=NONE cterm=NONE gui=NONE ctermfg=Green ctermbg=NONE guifg=Black guibg=NONE

syntax match rallyTaskFields /\(ID    \|DefectName  \|TaskName  \| Owner  \| Est \| ToDo \| State \)/
highlight rallyTaskFields term=bold cterm=NONE gui=bold ctermfg=DARKMAGENTA ctermbg=NONE guifg=DARKMAGENTA guibg=NONE

syntax match rallyDefectFields /\( State \| Environment \| Priority \| Severity \| Submitted By \| Creation Date \| Found In \| Fixed In \| Target Build \| Verified In \| Resolution \| Target Date \| Release Note \| Affects Doc \| User Story \)/
highlight rallyDefectFields term=bold cterm=NONE gui=bold ctermfg=DARKMAGENTA ctermbg=NONE guifg=DARKMAGENTA guibg=NONE

syntax match rallyTaskSchedule /\(Story\ State\|Task\ Estimate\|Task\ Todo\) |/
highlight rallyTaskSchedule term=bold cterm=bold gui=bold ctermfg=White ctermbg=NONE guifg=White guibg=None


syntax match rallyInfo /\(Base URL:\|Version:\|Username:\|Workspace:\|Project:\|Iteration:\|>.*:\)/
highlight rallyInfo term=bold cterm=bold gui=bold ctermfg=YELLOW ctermbg=NONE guifg=YELLOW guibg=NONE
syntax match rallyInfoDetails /\(> iteration unit:\|, release unit:\|, task unit:\|>.*:\)/
highlight rallyInfoDetails term=bold cterm=bold gui=bold ctermfg=GREY ctermbg=NONE guifg=GREY guibg=NONE

syntax match rallyDashboardTitles /\(Blocked\|My Tasks\|My Test Cases\|My Defects\)/
highlight rallyDashboardTitles term=bold cterm=bold gui=bold ctermfg=YELLOW ctermbg=BLUE guifg=YELLOW guibg=BLUE

syntax match rallyBannerLoadingData /Loading\ Rally\ Data/
highlight rallyBannerLoadingData term=bold cterm=bold gui=bold ctermfg=BLUE ctermbg=NONE guifg=BLUE guibg=NONE

"====================================================
"
" ********************
" Charts
" ********************

syntax match rallyBurndownChartTaskTodo /\(#\)/
highlight rallyBurndownChartTaskTodo term=bold cterm=bold gui=bold ctermfg=BLUE ctermbg=NONE guifg=BLUE guibg=NONE

syntax match rallyBurndownChartAcceptedPoints /\(@\)/
highlight rallyBurndownChartAcceptedPoints term=bold cterm=bold gui=bold ctermfg=GREEN ctermbg=NONE guifg=GREEN guibg=NONE

syntax match rallyBurndownChartRowMarker /\(\.\.\)/
highlight rallyBurndownChartRowMarker term=bold cterm=bold gui=bold ctermfg=RED ctermbg=NONE guifg=RED guibg=NONE

syntax match rallyBurndownChartTrendline /\(-\)/
highlight rallyBurndownChartTrendline term=bold cterm=bold gui=bold ctermfg=WHITE ctermbg=NONE guifg=WHITE guibg=NONE

" cumulative flow
syntax match rallyCumulativeFlowChartAcceptedPoints /\(@\)/
highlight rallyCumulativeFlowChartAcceptedPoints term=bold cterm=bold gui=bold ctermfg=GREEN ctermbg=NONE guifg=GREEN guibg=NONE
syntax match rallyCumulativeFlowChartCompletedPoints /\(%\)/
highlight rallyCumulativeFlowChartCompletedPoints term=bold cterm=bold gui=bold ctermfg=YELLOW ctermbg=NONE guifg=YELLOW guibg=NONE
syntax match rallyCumulativeFlowChartInProgressPoints /\(#\)/
highlight rallyCumulativeFlowChartInProgressPoints term=bold cterm=bold gui=bold ctermfg=BLUE ctermbg=NONE guifg=BLUE guibg=NONE
syntax match rallyCumulativeFlowChartDefinedPoints /\(\*\)/
highlight rallyCumulativeFlowChartDefinedPoints term=bold cterm=bold gui=bold ctermfg=LIGHTGRAY ctermbg=NONE guifg=LIGHTGRAY guibg=NONE


"====================================================

let b:current_syntax = "rally"

if main_syntax == 'rally'
  unlet main_syntax
endif

