" Mini Buffer Explorer <minibufexpl.vim>
"
" HINT: Type zR if you don't know how to use folds
"
" Script Info and Documentation  {{{
"=============================================================================
"     Copyright: Copyright (C) 2002 & 2003 Bindu Wavell 
"                Copyright (C) 2010 Oliver Uvman
"                Copyright (C) 2010 Danielle Church
"                Copyright (C) 2010 Stephan Sokolow
"                Copyright (C) 2010 & 2011 Federico Holgado
"                Permission is hereby granted to use and distribute this code,
"                with or without modifications, provided that this copyright
"                notice is copied with it. Like anything else that's free,
"                minibufexpl.vim is provided *as is* and comes with no
"                warranty of any kind, either expressed or implied. In no
"                event will the copyright holder be liable for any damamges
"                resulting from the use of this software.
" 
"  Name Of File: minibufexpl.vim
"   Description: Mini Buffer Explorer Vim Plugin
" Documentation: See minibufexpl.txt
"
"=============================================================================
" }}}
"
" Startup Check
"
" Has this plugin already been loaded? {{{
"
if exists('loaded_minibufexplorer')
  finish
endif
let loaded_minibufexplorer = 1
" }}}

" Mappings and Commands
"
" MBE Keyboard Mappings {{{
" If we don't already have keyboard mappings for MBE then create them 
" 
if !hasmapto('<Plug>MiniBufExplorer')
  map <unique> <Leader>mbe <Plug>MiniBufExplorer
endif
if !hasmapto('<Plug>CMiniBufExplorer')
  map <unique> <Leader>mbc <Plug>CMiniBufExplorer
endif
if !hasmapto('<Plug>UMiniBufExplorer')
  map <unique> <Leader>mbu <Plug>UMiniBufExplorer
endif
if !hasmapto('<Plug>TMiniBufExplorer')
  map <unique> <Leader>mbt <Plug>TMiniBufExplorer
endif
if !hasmapto('<Plug>MBEMarkCurrent')
  map <unique> <Leader>mq <Plug>MBEMarkCurrent
endif
" }}}
" MBE <Script> internal map {{{
" 
noremap <unique> <script> <Plug>MiniBufExplorer  :call <SID>StartExplorer(1, -1, bufnr("%"))<CR>:<BS>
noremap <unique> <script> <Plug>CMiniBufExplorer :call <SID>StopExplorer(1)<CR>:<BS>
noremap <unique> <script> <Plug>UMiniBufExplorer :call <SID>AutoUpdate(-1,bufnr("%"))<CR>:<BS>
noremap <unique> <script> <Plug>TMiniBufExplorer :call <SID>ToggleExplorer()<CR>:<BS>
noremap <unique> <script> <Plug>MBEMarkCurrent :call <SID>MarkCurrentBuffer(bufname("%"),1)<CR>:<BS>

" }}}
" MBE commands {{{
" 
if !exists(':MiniBufExplorer')
  command! MiniBufExplorer  call <SID>StartExplorer(1, -1, bufnr("%"))
endif
if !exists(':CMiniBufExplorer')
  command! CMiniBufExplorer  call <SID>StopExplorer(1)
endif
if !exists(':UMiniBufExplorer')
  command! UMiniBufExplorer  call <SID>AutoUpdate(-1,bufnr("%"))
endif
if !exists(':TMiniBufExplorer')
  command! TMiniBufExplorer  call <SID>ToggleExplorer()
endif
if !exists(':MBEbn')
  command! MBEbn call <SID>CycleBuffer(1)
endif
if !exists(':MBEbp')
  command! MBEbp call <SID>CycleBuffer(0)
endif " }}}

" Global Configuration Variables
"
" Debug Level {{{
"
" 0 = no logging
" 1=5 = errors ; 1 is the most important
" 5-9 = info ; 5 is the most important
" 10 = Entry/Exit
if !exists('g:miniBufExplorerDebugLevel')
  let g:miniBufExplorerDebugLevel = 1
endif

" }}}
" Debug Mode {{{
"
" 0 = debug to a window
" 1 = use vim's echo facility
" 2 = write to a file named MiniBufExplorer.DBG
"     in the directory where vim was started
"     THIS IS VERY SLOW
" 3 = Write into g:miniBufExplorerDebugOutput
"     global variable [This is the default]
if !exists('g:miniBufExplorerDebugMode')
  let g:miniBufExplorerDebugMode = 3
endif 

" }}}
" Allow auto update? {{{
"
" We start out with this off for startup, but once vim is running we 
" turn this on.
if !exists('g:miniBufExplorerAutoUpdate')
  let g:miniBufExplorerAutoUpdate = 0
endif

" }}}
" MoreThanOne? {{{
" Display Mini Buf Explorer when there are 'More Than One' eligible buffers 
"
if !exists('g:miniBufExplorerMoreThanOne')
  let g:miniBufExplorerMoreThanOne = 2
endif 

" }}}
" Split below/above/left/right? {{{
" When opening a new -MiniBufExplorer- window, split the new windows below or 
" above the current window?  1 = below, 0 = above.
"
if !exists('g:miniBufExplSplitBelow')
  let g:miniBufExplSplitBelow = &splitbelow
endif 

" }}}
" Split to edge? {{{
" When opening a new -MiniBufExplorer- window, split the new windows to the
" full edge? 1 = yes, 0 = no.
"
if !exists('g:miniBufExplSplitToEdge')
  let g:miniBufExplSplitToEdge = 1
endif 

" }}}
" MaxHeight (depreciated) {{{
" When sizing the -MiniBufExplorer- window, assign a maximum window height.
" 0 = size to fit all buffers, otherwise the value is number of lines for
" buffer. [Depreciated use g:miniBufExplMaxSize]
"
if !exists('g:miniBufExplMaxHeight')
  let g:miniBufExplMaxHeight = 0
endif 

" }}}
" MaxSize {{{
" Same as MaxHeight but also works for vertical splits if specified with a
" vertical split then vertical resizing will be performed. If left at 0 
" then the number of columns in g:miniBufExplVSplit will be used as a
" static window width.
if !exists('g:miniBufExplMaxSize')
  let g:miniBufExplMaxSize = g:miniBufExplMaxHeight
endif

" }}}
" MinHeight (depreciated) {{{
" When sizing the -MiniBufExplorer- window, assign a minumum window height.
" the value is minimum number of lines for buffer. Setting this to zero can
" cause strange height behavior. The default value is 1 [Depreciated use
" g:miniBufExplMinSize]
"
if !exists('g:miniBufExplMinHeight')
  let g:miniBufExplMinHeight = 1
endif

" }}}
" MinSize {{{
" Same as MinHeight but also works for vertical splits. For vertical splits, 
" this is ignored unless g:miniBufExplMax(Size|Height) are specified.
if !exists('g:miniBufExplMinSize')
  let g:miniBufExplMinSize = g:miniBufExplMinHeight
endif

" }}}
" Horizontal or Vertical explorer? {{{
" For folks that like vertical explorers, I'm caving in and providing for
" veritcal splits. If this is set to 0 then the current horizontal 
" splitting logic will be run. If however you want a vertical split,
" assign the width (in characters) you wish to assign to the MBE window.
"
if !exists('g:miniBufExplVSplit')
  let g:miniBufExplVSplit = 0
endif

" }}}
" TabWrap? {{{
" By default line wrap is used (possibly breaking a tab name between two
" lines.) Turning this option on (setting it to 1) can take more screen
" space, but will make sure that each tab is on one and only one line.
"
if !exists('g:miniBufExplTabWrap')
  let g:miniBufExplTabWrap = 0
endif

" }}}
" ShowBufNumber? {{{
" By default buffers' numbers are shown in MiniBufExplorer. You can turn it off
" by setting this option to 0.
"
if !exists('g:miniBufExplShowBufNumbers')
  let g:miniBufExplShowBufNumbers = 1
endif

" }}}
" Extended window navigation commands? {{{
" Global flag to turn extended window navigation commands on or off
" enabled = 1, dissabled = 0
"
if !exists('g:miniBufExplMapWindowNav')
  " This is for backwards compatibility and may be removed in a
  " later release, please use the ...NavVim and/or ...NavArrows 
  " settings.
  let g:miniBufExplMapWindowNav = 0
endif
if !exists('g:miniBufExplMapWindowNavVim')
  let g:miniBufExplMapWindowNavVim = 0
endif
if !exists('g:miniBufExplMapWindowNavArrows')
  let g:miniBufExplMapWindowNavArrows = 0
endif
if !exists('g:miniBufExplMapCTabSwitchBufs')
  let g:miniBufExplMapCTabSwitchBufs = 0
endif
" Notice: that if CTabSwitchBufs is turned on then
" we turn off CTabSwitchWindows.
if g:miniBufExplMapCTabSwitchBufs == 1 || !exists('g:miniBufExplMapCTabSwitchWindows')
  let g:miniBufExplMapCTabSwitchWindows = 0
endif 

"
" If we have enabled control + vim direction key remapping
" then perform the remapping
"
" Notice: I left g:miniBufExplMapWindowNav in for backward
" compatibility. Eventually this mapping will be removed so
" please use the newer g:miniBufExplMapWindowNavVim setting.
if g:miniBufExplMapWindowNavVim || g:miniBufExplMapWindowNav
  noremap <C-J> <C-W>j
  noremap <C-K> <C-W>k
  noremap <C-H> <C-W>h
  noremap <C-L> <C-W>l
endif

"
" If we have enabled control + arrow key remapping
" then perform the remapping
"
if g:miniBufExplMapWindowNavArrows
  noremap <C-Down>  <C-W>j
  noremap <C-Up>    <C-W>k
  noremap <C-Left>  <C-W>h
  noremap <C-Right> <C-W>l
endif

" If we have enabled <C-TAB> and <C-S-TAB> to switch buffers
" in the current window then perform the remapping
"
if g:miniBufExplMapCTabSwitchBufs
  noremap <C-TAB>   :call <SID>CycleBuffer(1)<CR>:<BS>
  noremap <C-S-TAB> :call <SID>CycleBuffer(0)<CR>:<BS>
endif

"
" If we have enabled <C-TAB> and <C-S-TAB> to switch windows
" then perform the remapping
"
if g:miniBufExplMapCTabSwitchWindows
  noremap <C-TAB>   <C-W>w
  noremap <C-S-TAB> <C-W>W
endif

" }}}
" Modifiable Select Target {{{
"
if !exists('g:miniBufExplModSelTarget')
  let g:miniBufExplModSelTarget = 0
endif

"}}}
" Force Syntax Enable {{{
"
if !exists('g:miniBufExplForceSyntaxEnable')
  let g:miniBufExplForceSyntaxEnable = 0
endif

" }}}
" Single/Double Click? {{{
" flag that can be set to 1 in a users .vimrc to allow 
" single click switching of tabs. By default we use
" double click for tab selection.

if !exists('g:miniBufExplUseSingleClick')
  let g:miniBufExplUseSingleClick = 0
endif 

"
" attempt to perform single click mapping, it would be much
" nicer if we could nnoremap <buffer> ... however vim does
" not fire the <buffer> <leftmouse> when you use the mouse
" to enter a buffer.
"
if g:miniBufExplUseSingleClick == 1
  let s:clickmap = ':if bufname("%") == "-MiniBufExplorer-" <bar> call <SID>MBEClick() <bar> endif <CR>'
  if maparg('<LEFTMOUSE>', 'n') == '' 
    " no mapping for leftmouse
    exec ':nnoremap <silent> <LEFTMOUSE> <LEFTMOUSE>' . s:clickmap
  else
    " we have a mapping
    let  g:miniBufExplDoneClickSave = 1
    let  s:m = ':nnoremap <silent> <LEFTMOUSE> <LEFTMOUSE>'
    let  s:m = s:m . substitute(substitute(maparg('<LEFTMOUSE>', 'n'), '|', '<bar>', 'g'), '\c^<LEFTMOUSE>', '', '')
    let  s:m = s:m . s:clickmap
    exec s:m
  endif
endif " }}}
" Close on Select? {{{
" Flag that can be set to 1 in a users .vimrc to hide
" the explorer when a user selects a buffer.
"
if !exists('g:miniBufExplCloseOnSelect')
  let g:miniBufExplCloseOnSelect = 0
endif " }}}
" Check for duplicate buffer names? {{{
" Flag that can be set to 0 in a users .vimrc to turn off
" the explorer's feature that differentiates similar buffer names by
" displaying the parent directory names. This feature should be turned off
" if you work with a large number of buffers (>15) simultaneously.
"
if !exists('g:miniBufExplCheckDupeBufs')
  let g:miniBufExplCheckDupeBufs = 1
endif " }}}

" Variables used internally
"
" Script/Global variables {{{
" Global used to store the buffer list so we don't update the
" UI unless the list has changed.
if !exists('g:miniBufExplBufList')
  let g:miniBufExplBufList = ''
endif

" Variable used as a mutex so that we don't do lots
" of AutoUpdates at the same time.
if !exists('g:miniBufExplInAutoUpdate')
  let g:miniBufExplInAutoUpdate = 0
endif

" In debug mode 3 this variable will hold the debug output
if !exists('g:miniBufExplorerDebugOutput')
  let g:miniBufExplorerDebugOutput = ''
endif

" In debug mode 3 this variable will hold the debug output
if !exists('g:miniBufExplForceDisplay')
  let g:miniBufExplForceDisplay = 0
endif

if !exists('g:miniBufExplSortBy')
  let g:miniBufExplSortBy = "number"
endif

if !exists('g:statusLineText')
  let g:statusLineText = "-MiniBufExplorer-"
endif

" Variable used to pass maxTabWidth info between functions
let s:maxTabWidth = 0 

" Variable used to count debug output lines
let s:debugIndex = 0 

" Build initial MRUList. This makes sure all the files specified on the
" command line are picked up correctly.
let s:MRUList = range(1, bufnr('$'))
  
" }}}
" Setup an autocommand group and some autocommands {{{
" that keep our explorer updated automatically.
"

"set update time for the CursorHold function so that it is called 100ms after
"a key is pressed
setlocal updatetime=300

augroup MiniBufExplorer
autocmd MiniBufExplorer BufDelete      * call <SID>DEBUG('-=> BufDelete AutoCmd', 10) |call <SID>AutoUpdate(expand('<abuf>'),bufnr("%"))
autocmd MiniBufExplorer BufDelete      * call <SID>DEBUG('-=> BufDelete ModTrackingListClean AutoCmd for buffer '.bufnr("%"), 10) |call <SID>CleanModTrackingList(bufnr("%"))
autocmd MiniBufExplorer BufEnter       * call <SID>DEBUG('-=> BufEnter AutoCmd', 10) |call <SID>AutoUpdate(-1,bufnr("%"))
autocmd MiniBufExplorer BufEnter       * call <SID>DEBUG('-=> BufEnter Checking for Last window', 10) |call <SID>CheckForLastWindow()
autocmd MiniBufExplorer BufWritePost   * call <SID>DEBUG('-=> BufWritePost AutoCmd', 10) |call <SID>AutoUpdate(-1,bufnr("%"))
autocmd MiniBufExplorer CursorHold     * call <SID>DEBUG('-=> CursroHold AutoCmd', 10) |call <SID>AutoUpdateCheck(bufnr("%"))
autocmd MiniBufExplorer CursorHoldI    * call <SID>DEBUG('-=> CursorHoldI AutoCmd', 10) |call <SID>AutoUpdateCheck(bufnr("%"))
autocmd MiniBufExplorer VimEnter       * call <SID>DEBUG('-=> VimEnter AutoCmd', 10) |let g:miniBufExplorerAutoUpdate = 1 |call <SID>AutoUpdate(-1,bufnr("%"))
augroup NONE
" }}}

" Functions
" EscapeTilde - escapes "~" {{{
function! <SID>EscapeTilde(str)
   return substitute(a:str, "\\\~","\\\\\~","g")
endfunction
" }}}
"
" StartExplorer - Sets up our explorer and causes it to be displayed {{{
"
function! <SID>StartExplorer(sticky,delBufNum,currBufName)
  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Entering StartExplorer()'   ,10)
  call <SID>DEBUG('===========================',10)

  if a:sticky == 1
    let g:miniBufExplorerAutoUpdate = 1
  endif

  " Store the current buffer
  let l:curBuf = bufnr('%')

  " Prevent a report of our actions from showing up.
  let l:save_rep = &report
  let l:save_sc  = &showcmd
  let &report    = 10000
  set noshowcmd 

  call <SID>FindCreateWindow('-MiniBufExplorer-', -1, 1, 1)

  " Make sure we are in our window
  if bufname('%') != '-MiniBufExplorer-'
    call <SID>DEBUG('StartExplorer called in invalid window',1)
    let &report  = l:save_rep
    let &showcmd = l:save_sc
    return
  endif

  " !!! We may want to make the following optional -- Bindu
  " New windows don't cause all windows to be resized to equal sizes
  set noequalalways
  " !!! We may want to make the following optional -- Bindu
  " We don't want the mouse to change focus without a click
  set nomousefocus

  " If folks turn numbering and columns on by default we will turn 
  " them off for the MBE window
  setlocal foldcolumn=0
  setlocal nonumber
  "don't highlight matching parentheses, etc.
  setlocal matchpairs=
  "Depending on what type of split, make sure the MBE buffer is not
  "automatically rezised by CTRL + W =, etc...
  setlocal winfixheight
  setlocal winfixwidth
  
  " Set shellslash for Windows/DOS Vim for dupeBufName checking to Work
  if (has("win32") || has("win64"))
      set shellslash
  endif

  " Set the text of the statusline for the MBE buffer. See help:stl for
  " many options
  setlocal stl=%!g:statusLineText

  " No spell check
  setlocal nospell
  " Restore colorcolumn for VIM >= 7.3
  if exists("+colorcolumn")
      setlocal colorcolumn&
  end
 
  if has("syntax")
    syn clear
    syn match MBENormal                   '\[[^\]]*\]'
    syn match MBEChanged                  '\[[^\]]*\]+'
    syn match MBEVisibleNormal            '\[[^\]]*\]\*+\='
    syn match MBEVisibleChanged           '\[[^\]]*\]\*+'
    syn match MBEVisibleActive            '\[[^\]]*\]\*!'
    syn match MBEVisibleChangedActive     '\[[^\]]*\]\*+!'

    "MiniBufExpl Color Examples
    " hi MBEVisibleActive guifg=#A6DB29 guibg=fg
    " hi MBEVisibleChangedActive guifg=#F1266F guibg=fg
    " hi MBEVisibleChanged guifg=#F1266F guibg=fg
    " hi MBEVisibleNormal guifg=#5DC2D6 guibg=fg
    " hi MBEChanged guifg=#CD5907 guibg=fg
    " hi MBENormal guifg=#808080 guibg=fg
    
    if !exists("g:did_minibufexplorer_syntax_inits")
      let g:did_minibufexplorer_syntax_inits = 1
      hi def link MBENormal                Comment
      hi def link MBEChanged               String
      hi def link MBEVisibleNormal         Special
      hi def link MBEVisibleActive         Boolean
      hi def link MBEVisibleChanged        Special
      hi def link MBEVisibleChangedActive  Error
    endif
  endif

  " If you press return, o or e in the -MiniBufExplorer- then try
  " to open the selected buffer in the previous window.
  nnoremap <buffer> <CR> :call <SID>MBESelectBuffer(0)<CR>:<BS>
  nnoremap <buffer> o :call <SID>MBESelectBuffer(0)<CR>:<BS>
  nnoremap <buffer> e :call <SID>MBESelectBuffer(0)<CR>:<BS>
  " If you press s in the -MiniBufExplorer- then try
  " to open the selected buffer in a split in the previous window.
  nnoremap <buffer> s :call <SID>MBESelectBuffer(1)<CR>:<BS>
  " If you press j in the -MiniBufExplorer- then try
  " to open the selected buffer in a vertical split in the previous window.
  nnoremap <buffer> v :call <SID>MBESelectBuffer(2)<CR>:<BS>
  " If you DoubleClick in the -MiniBufExplorer- then try
  " to open the selected buffer in the previous window.
  nnoremap <buffer> <2-LEFTMOUSE> :call <SID>MBEDoubleClick()<CR>:<BS>
  " If you press d in the -MiniBufExplorer- then try to
  " delete the selected buffer.
  nnoremap <buffer> d :call <SID>MBEDeleteBuffer(bufname("#"))<CR>:<BS>
  " If you press w in the -MiniBufExplorer- then switch back
  " to the previous window.
  nnoremap <buffer> p :wincmd p<CR>:<BS>
  " The following allow us to use regular movement keys to 
  " scroll in a wrapped single line buffer
  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
  nnoremap <buffer> <down> gj
  nnoremap <buffer> <up> gk
  " The following allows for quicker moving between buffer
  " names in the [MBE] window it also saves the last-pattern
  " and restores it.
  nnoremap <buffer> <TAB>   :call search('\[[0-9]*:[^\]]*\]')<CR>:<BS>
  nnoremap <buffer> <S-TAB> :call search('\[[0-9]*:[^\]]*\]','b')<CR>:<BS>
  nnoremap <buffer> l   :call search('\[[0-9]*:[^\]]*\]')<CR>:<BS>
  nnoremap <buffer> h :call search('\[[0-9]*:[^\]]*\]','b')<CR>:<BS>
 
  call <SID>DisplayBuffers(a:delBufNum,a:currBufName)

  if (l:curBuf != -1)
    let l:bname = <SID>EscapeTilde(expand('#'.l:curBuf.':t'))
    call search('\['.l:curBuf.':'.l:bname.'\]')
  else
    call <SID>DEBUG('No current buffer to search for',9)
  endif

  let &report  = l:save_rep
  let &showcmd = l:save_sc

  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Completed StartExplorer()'  ,10)
  call <SID>DEBUG('===========================',10)

endfunction 

" }}}
" StopExplorer - Looks for our explorer and closes the window if it is open {{{
"
function! <SID>StopExplorer(sticky)
  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Entering StopExplorer()'    ,10)
  call <SID>DEBUG('===========================',10)

  if a:sticky == 1
    let g:miniBufExplorerAutoUpdate = 0
  endif

  let l:winNum = <SID>FindWindow('-MiniBufExplorer-', 1)

  if l:winNum != -1 
    exec l:winNum.' wincmd w'
    silent! close
    wincmd p

    " Work around a redraw bug in gVim (Confirmed present in 7.3.50)
    if has('gui_gtk') && has('gui_running')
        redraw!
    endif
  endif

  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Completed StopExplorer()'   ,10)
  call <SID>DEBUG('===========================',10)

endfunction

" }}}
" ToggleExplorer - Looks for our explorer and opens/closes the window {{{
"
function! <SID>ToggleExplorer()
  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Entering ToggleExplorer()'  ,10)
  call <SID>DEBUG('===========================',10)

  let g:miniBufExplorerAutoUpdate = 0

  let l:winNum = <SID>FindWindow('-MiniBufExplorer-', 1)

  if l:winNum != -1 
    call <SID>StopExplorer(1)
  else
    call <SID>StartExplorer(1, -1, bufnr("%"))
    wincmd p
  endif

  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Completed ToggleExplorer()' ,10)
  call <SID>DEBUG('===========================',10)

endfunction

" }}}
" FindWindow - Return the window number of a named buffer {{{
" If none is found then returns -1. 
"
function! <SID>FindWindow(bufName, doDebug)
  if a:doDebug
    call <SID>DEBUG('Entering FindWindow()',10)
  endif

  " Try to find an existing window that contains 
  " our buffer.
  let l:bufNum = bufnr(a:bufName)
  if l:bufNum != -1
    if a:doDebug
      call <SID>DEBUG('Found buffer ('.a:bufName.'): '.l:bufNum,9)
    endif
    let l:winNum = bufwinnr(l:bufNum)
  else
    let l:winNum = -1
  endif

  return l:winNum

endfunction

" }}}
" FindCreateWindow - Attempts to find a window for a named buffer. {{{
"
" If it is found then moves there. Otherwise creates a new window and 
" configures it and moves there.
"
" forceEdge, -1 use defaults, 0 below, 1 above
" isExplorer, 0 no, 1 yes 
" doDebug, 0 no, 1 yes
"
function! <SID>FindCreateWindow(bufName, forceEdge, isExplorer, doDebug)
  if a:doDebug
    call <SID>DEBUG('Entering FindCreateWindow('.a:bufName.')',10)
  endif

  " Save the user's split setting.
  let l:saveSplitBelow = &splitbelow

  " Set to our new values.
  let &splitbelow = g:miniBufExplSplitBelow

  " Try to find an existing explorer window
  let l:winNum = <SID>FindWindow(a:bufName, a:doDebug)

  " If found goto the existing window, otherwise 
  " split open a new window.
  if l:winNum != -1
    if a:doDebug
      call <SID>DEBUG('Found window ('.a:bufName.'): '.l:winNum,9)
    endif
    exec l:winNum.' wincmd w'
    let l:winFound = 1
  else

      if g:miniBufExplSplitToEdge == 1 || a:forceEdge >= 0

          let l:edge = &splitbelow
          if a:forceEdge >= 0
              let l:edge = a:forceEdge
          endif

          if l:edge
              if g:miniBufExplVSplit == 0
                  exec 'bo sp '.a:bufName
              else
                  exec 'bo vsp '.a:bufName
              endif
          else
              if g:miniBufExplVSplit == 0
                  exec 'to sp '.a:bufName
              else
                  exec 'to vsp '.a:bufName
              endif
          endif
      else
          if g:miniBufExplVSplit == 0
              exec 'sp '.a:bufName
          else
              " &splitbelow doesn't affect vertical splits
              " so we have to do this explicitly.. ugh.
              if &splitbelow
                  exec 'rightb vsp '.a:bufName
              else
                  exec 'vsp '.a:bufName
              endif
          endif
      endif

    let g:miniBufExplForceDisplay = 1

    " Try to find an existing explorer window
    let l:winNum = <SID>FindWindow(a:bufName, a:doDebug)
    if l:winNum != -1
      if a:doDebug
        call <SID>DEBUG('Created and then found window ('.a:bufName.'): '.l:winNum,9)
      endif
      exec l:winNum.' wincmd w'
    else
      if a:doDebug
        call <SID>DEBUG('FindCreateWindow failed to create window ('.a:bufName.').',1)
      endif
      return
    endif

    if a:isExplorer
      " Turn off the swapfile, set the buffer type so that it won't get written,
      " and so that it will get deleted when it gets hidden and turn on word wrap.
      setlocal noswapfile
      setlocal buftype=nofile
      setlocal bufhidden=delete
      if g:miniBufExplVSplit == 0
        setlocal wrap
      else
        setlocal nowrap
        exec('setlocal winwidth='.g:miniBufExplMinSize)
      endif
    endif

    if a:doDebug
      call <SID>DEBUG('Window ('.a:bufName.') created: '.winnr(),9)
    endif

  endif

  " Restore the user's split setting.
  let &splitbelow = l:saveSplitBelow

endfunction

" }}}
" DisplayBuffers - Wrapper for getting MBE window shown {{{
"
" Makes sure we are in our explorer, then erases the current buffer and turns 
" it into a mini buffer explorer window.
"
function! <SID>DisplayBuffers(delBufNum,currBufName)
  call <SID>DEBUG('Entering DisplayBuffers()',10)
  
  " Make sure we are in our window
  if bufname('%') != '-MiniBufExplorer-'
    call <SID>DEBUG('DisplayBuffers called in invalid window',1)
    return
  endif

  " We need to be able to modify the buffer
  setlocal modifiable

  call <SID>ShowBuffers(a:delBufNum,a:currBufName)
  call <SID>ResizeWindow()
  
  normal! zz
  
  " Prevent the buffer from being modified.
  setlocal nomodifiable
  set nobuflisted

endfunction

" }}}
" Resize Window - Set width/height of MBE window {{{
" 
" Makes sure we are in our explorer, then sets the height/width for our explorer 
" window so that we can fit all of our information without taking extra lines.
"
function! <SID>ResizeWindow()
  call <SID>DEBUG('Entering ResizeWindow()',10)

  " Make sure we are in our window
  if bufname('%') != '-MiniBufExplorer-'
    call <SID>DEBUG('ResizeWindow called in invalid window',1)
    return
  endif

  let l:width  = winwidth('.')

  " Horizontal Resize
  if g:miniBufExplVSplit == 0

    if g:miniBufExplTabWrap == 0
      let l:length = strlen(getline('.'))
      let l:height = 0
      if (l:width == 0)
        let l:height = winheight('.')
      else
        let l:height = (l:length / l:width) 
        " handle truncation from div
        if (l:length % l:width) != 0
          let l:height = l:height + 1
        endif
      endif
    else
      exec("setlocal textwidth=".l:width)
      normal gg
      normal gq}
      normal G
      let l:height = line('.')
      normal gg
    endif
  
    " enforce max window height
    if g:miniBufExplMaxSize != 0
      if g:miniBufExplMaxSize < l:height
        let l:height = g:miniBufExplMaxSize
      endif
    endif
  
    " enfore min window height
    if l:height < g:miniBufExplMinSize || l:height == 0
      let l:height = g:miniBufExplMinSize
    endif
  
    call <SID>DEBUG('ResizeWindow to '.l:height.' lines',9)
  
    exec('resize '.l:height)
  
  " Vertical Resize
  else 

    if g:miniBufExplMaxSize != 0
      let l:newWidth = s:maxTabWidth
      if l:newWidth > g:miniBufExplMaxSize 
          let l:newWidth = g:miniBufExplMaxSize
      endif
      if l:newWidth < g:miniBufExplMinSize
          let l:newWidth = g:miniBufExplMinSize
      endif
    else
      let l:newWidth = g:miniBufExplVSplit
    endif

    if l:width != l:newWidth
      call <SID>DEBUG('ResizeWindow to '.l:newWidth.' columns',9)
      exec('vertical resize '.l:newWidth)
    endif

  endif
  
endfunction

" }}}
" ShowBuffers - Clear current buffer and put the MBE text into it {{{
" 
" Makes sure we are in our explorer, then adds a list of all modifiable 
" buffers to the current buffer. Special marks are added for buffers that 
" are in one or more windows (*) and buffers that have been modified (+)
"
function! <SID>ShowBuffers(delBufNum,currBufName)
  call <SID>DEBUG('Entering ShowBuffers()',10)

  let l:ListChanged = <SID>BuildBufferList(a:delBufNum, 1, a:currBufName)

  if (l:ListChanged == 1 || g:miniBufExplForceDisplay)
    let l:save_rep = &report
    let l:save_sc = &showcmd
    let &report = 10000
    set noshowcmd 

    " Delete all lines in buffer.
    1,$d _
  
    " Goto the end of the buffer put the buffer list 
    " and then delete the extra trailing blank line
    $
    put! =g:miniBufExplBufList
    $ d _

    let g:miniBufExplForceDisplay = 0

    let &report  = l:save_rep
    let &showcmd = l:save_sc
  else
    call <SID>DEBUG('Buffer list not update since there was no change',9)
  endif
  
endfunction

" }}}
" Max - Returns the max of two numbers {{{
"
function! <SID>Max(argOne, argTwo)
  if a:argOne > a:argTwo
    return a:argOne
  else
    return a:argTwo
  endif
endfunction

" }}}
" CheckRootDirForDupes - Checks if the buffer parent dirs are the same {{{
" 
" Compares 2 buffers with the same filename and returns the directory of
" buffer 1's path at the point where it is different from buffer 2's path
"
function! CheckRootDirForDupes(level,path1,path2)
    call <SID>DEBUG('Entering Dupe Dir Checking Function for at level '.a:level.' for '.join(a:path1).' vs '.join(a:path2),10)
    if(len(a:path1) >= abs(a:level))
        call <SID>DEBUG('Path level1 is '.get(a:path1,a:level),10)
        call <SID>DEBUG('Path level2 is '.get(a:path2,a:level),10)
        if(get(a:path1,a:level) == get(a:path2,a:level))
            let s:bufPathPosition = a:level - 1
            call CheckRootDirForDupes(s:bufPathPosition,a:path1,a:path2)
            call <SID>DEBUG('Match in directory name at level '.a:level,10)
            call <SID>DEBUG('Calling CheckRootForDupes again',10)
        else
            call <SID>DEBUG('Final path Position is '.s:bufPathPosition,10)
            let s:bufPathPrefix = a:path1[s:bufPathPosition].'/'
            call <SID>DEBUG('Found non-matching root dir and it is '.s:bufPathPrefix,10)
        endif
    endif
endfunction

" }}}
" IgnoreBuffer - check to see if buffer should be ignored {{{
"
" Returns 0 if this buffer should be displayed in the list, 1 otherwise.
"
function! <SID>IgnoreBuffer(buf)
  " Skip temporary buffers with buftype set.
  if empty(getbufvar(a:buf, "&buftype") == 0)
    return 1
  endif

  " Skip unlisted buffers.
  if buflisted(a:buf) == 0
    return 1
  endif

  " Skip buffers with no name.
  let l:BufName = bufname(a:buf)
  if empty(l:BufName) == 1
    return 1
  endif

  " Only show modifiable buffers (The idea is that we don't 
  " want to show Explorers)
  if (getbufvar(a:buf, '&modifiable') != 1 || l:BufName == '-MiniBufExplorer-')
    return 1
  endif

  return 0 
endfunction

" }}}
" BuildBufferList - Build the text for the MBE window {{{
" 
" Creates the buffer list string and returns 1 if it is different than
" last time this was called and 0 otherwise.
"
function! <SID>BuildBufferList(delBufNum, updateBufList, currBufName)
    call <SID>DEBUG('Entering BuildBufferList()',10)


    let l:CurrBufName = a:currBufName
    let l:NBuffers = bufnr('$')     " Get the number of the last buffer.
    let l:i = 0                     " Set the buffer index to zero.

    let l:fileNames = ''
    let l:tabList = []
    let l:maxTabWidth = 0
    " default separator for *nix file systems
    let s:PathSeparator = '/'
    " counter to see what platform we may be in
    let l:nixPlatform = 0
    let l:winPlatform = 0

    " Loop through every buffer less than the total number of buffers.
    while(l:i <= l:NBuffers)
        let l:i = l:i + 1

        " If we have a delBufNum and it is the current
        " buffer then ignore the current buffer. 
        " Otherwise, continue.

        if (a:delBufNum == l:i)
            " check to see what platform we are in
            if (has('unix'))
                let s:PathSeparator = '/'
                call <SID>DEBUG('separator set to  '.s:PathSeparator,10)
            else
                let s:PathSeparator = '\'
                call <SID>DEBUG('separator set to  '.s:PathSeparator,10)
            endif

            call <SID>DEBUG('Separator is '.s:PathSeparator,10)

            continue
        endif

        if (<SID>IgnoreBuffer(l:i))
            continue
        endif

        if g:miniBufExplSortBy == "mru"
            let l:mruIdx = index(s:MRUList, l:i)
            if l:mruIdx == -1
                call add(s:MRUList, l:i)
            endif
        endif

        let l:BufName = expand( "#" . l:i . ":p:t")

        " See if buffer names are duplicate
        let l:dupeBufName = 0
        let l:i2 = 0
        " Establish initial parent directory position
        let s:bufPathPosition = -2
        let s:bufPathPrefix = ""
        let l:pathList = []

        " While in current buffer from first loop, loop through all buffers
        " again!
        if (g:miniBufExplCheckDupeBufs == 1)
            while(l:i2 <= l:NBuffers)
                " Get the full path of the current buffer in the loop and the
                " current buffer in the new loop
                let l:i2 = l:i2 + 1
                let l:bufPath = expand( "#" . l:i . ":p")
                let l:bufPath2 = expand( "#" . l:i2 . ":p")
                let l:BufName2 = expand( "#" . l:i2 . ":p:t")      

                call <SID>DEBUG('BUFFER PATHS ---> bufPath is '.l:bufPath.' and bufPath2 is '.l:bufPath2,10)
                call <SID>DEBUG('BUFFER NAMES ---> bufName is '.l:BufName.' and BufName2 is '.l:BufName2,10)

                " Split the path string by delimiters
                let l:bufSplitPath = split(l:bufPath,s:PathSeparator,0)
                let l:bufSplitPath2 = split(l:bufPath2,s:PathSeparator,0)

                if((l:BufName2 != '') && (l:bufPath != l:bufPath2))
                    call <SID>DEBUG('bufPath2 is not empty and not comparing the same file, going to check for dupes!',10)

                    " Get the filename from each buffer to compare them
                    let l:bufFileNameFromPath = 'No Name'
                    if(strlen(l:BufName))
                        let l:bufFileNameFromPath = l:bufSplitPath[-1]
                        call <SID>DEBUG('Setting bufFileNameFromPath as '.l:bufSplitPath[-1],10)
                    endif

                    " Make sure to take into account empty buffers
                    let l:bufFileNameFromPath2 = 'No Name'
                    if(strlen(l:BufName2))
                        let l:bufFileNameFromPath2 = l:bufSplitPath2[-1]
                        call <SID>DEBUG('Setting bufFileNameFromPath2 as '.l:bufSplitPath2[-1],10)
                    endif

                    call <SID>DEBUG('Comparing '.l:bufPath.' vs '.l:bufPath2,10)

                    " If there is a match for buffer names, increase a variable
                    " that we'll check later

                    if (l:bufFileNameFromPath == l:bufFileNameFromPath2)
                        let l:dupeBufName = l:dupeBufName + 1
                        call <SID>DEBUG('dupeBufName equals '.l:dupeBufName,10)
                        " Now check to see if the parent directory matches if there
                        " are 2 or more buffers with the same name
                        if (l:bufPath2 != 'No Name')
                            let l:bufPathToCompare2 = l:bufPath2
                            let l:pathList = add(l:pathList,l:bufPath2)
                            call <SID>DEBUG('Adding '.l:bufPath2.' to pathList',10)
                        endif
                    endif
                endif
            endwhile   

            " If there are 2 or more buffers with the same name, let's call a
            " function that show a differentiating parent directory so that the name is unique.
            if l:dupeBufName >= 1
                for item in l:pathList
                    call <SID>DEBUG('Item in pathList loop is '.item,10)
                    if ((!empty(item)) && (item != l:bufPath))
                        call <SID>DEBUG('2 or more duplicate buffer names, calling dir check function with '.l:bufPath.' vs '.item,10)
                        call CheckRootDirForDupes(s:bufPathPosition,split(l:bufPath,s:PathSeparator,0),split(item,s:PathSeparator,0))
                    endif
                endfor
            endif
        endif

        " Establish the tab's content, including the differentiating root
        " dir if neccessary
        let l:tab = '['
        if g:miniBufExplShowBufNumbers == 1
            let l:tab .= l:i.':'
        endif

        if (g:miniBufExplCheckDupeBufs == 0)
            " Get filename & Remove []'s & ()'s
            let l:shortBufName = fnamemodify(l:BufName, ":t")                  
            let l:shortBufName = substitute(l:shortBufName, '[][()]', '', 'g') 
            let l:tab .= l:shortBufName.']'
        else

            let l:tab .= s:bufPathPrefix.l:bufSplitPath[-1].']'
        endif

        " If the buffer is open in a window mark it
        if bufwinnr(l:i) != -1
            let l:tab .= '*'
        endif

        " If the buffer is modified then mark it
        if(getbufvar(l:i, '&modified') == 1)
            let l:tab .= '+'
        endif

        " If the buffer matches the)current buffer name, then  mark it
        call <SID>DEBUG('l:i is '.l:i.' and l:CurrBufName is '.l:CurrBufName,10)
        if(l:i == l:CurrBufName)
            let l:tab .= '!'
        endif

        let l:maxTabWidth = <SID>Max(strlen(l:tab), l:maxTabWidth)
        call add(l:tabList, l:tab)

        if g:miniBufExplSortBy == "name"
            call sort(l:tabList, "<SID>NameCmp")
        elseif g:miniBufExplSortBy == "mru"
            call sort(l:tabList, "<SID>MRUCmp")
        endif

        let l:fileNames = ''
        for l:tab in l:tabList
            let l:fileNames = l:fileNames.l:tab

            " If horizontal and tab wrap is turned on we need to add spaces
            if g:miniBufExplVSplit == 0
                if g:miniBufExplTabWrap != 0
                    let l:fileNames = l:fileNames.' '
                endif
                " If not horizontal we need a newline
            else
                let l:fileNames = l:fileNames . "\n"
            endif
        endfor
    endwhile


    if (g:miniBufExplBufList != l:fileNames)
        if (a:updateBufList)
            let g:miniBufExplBufList = l:fileNames
            let s:maxTabWidth = l:maxTabWidth
        endif
        return 1
    else
        return 0
    endif

endfunction

" }}}
" NameCmp - compares tabs based on filename {{{
"
function! <SID>NameCmp(tab1, tab2)
  let l:name1 = matchstr(a:tab1, ":.*")
  let l:name2 = matchstr(a:tab2, ":.*")
  if l:name1 < l:name2
    return -1
  elseif l:name1 > l:name2
    return 1
  else
    return 0
  endif
endfunction

" }}}
" MRUCmp - compares tabs based on MRU order {{{
"
function! <SID>MRUCmp(tab1, tab2)
  let l:buf1 = str2nr(matchstr(a:tab1, '[0-9]\+'))
  let l:buf2 = str2nr(matchstr(a:tab2, '[0-9]\+'))
  return index(s:MRUList, l:buf1) - index(s:MRUList, l:buf2)
endfunction

" }}}
" HasEligibleBuffers - Are there enough MBE eligible buffers to open the MBE window? {{{
" 
" Returns 1 if there are any buffers that can be displayed in a 
" mini buffer explorer. Otherwise returns 0. If delBufNum is
" any non -1 value then don't include that buffer in the list
" of eligible buffers.
"
function! <SID>HasEligibleBuffers(delBufNum)
  call <SID>DEBUG('Entering HasEligibleBuffers()',10)

  let l:save_rep = &report
  let l:save_sc = &showcmd
  let &report = 10000
  set noshowcmd 
  
  let l:NBuffers = bufnr('$')     " Get the number of the last buffer.
  let l:i        = 0              " Set the buffer index to zero.
  let l:found    = 0              " No buffer found

  if (g:miniBufExplorerMoreThanOne > 1)
    call <SID>DEBUG('More Than One mode turned on',6)
  endif
  let l:needed = g:miniBufExplorerMoreThanOne

  " Loop through every buffer less than the total number of buffers.
  while(l:i <= l:NBuffers && l:found < l:needed)
    let l:i = l:i + 1
   
    " If we have a delBufNum and it is the current
    " buffer then ignore the current buffer. 
    " Otherwise, continue.
    if (a:delBufNum == -1 || l:i != a:delBufNum)
      " Make sure the buffer in question is listed.
      if (getbufvar(l:i, '&buflisted') == 1)
        " Get the name of the buffer.
        let l:BufName = bufname(l:i)
        " Check to see if the buffer is a blank or not. If the buffer does have
        " a name, process it.
        if (strlen(l:BufName))
          " Only show modifiable buffers (The idea is that we don't 
          " want to show Explorers)
          if ((getbufvar(l:i, '&modifiable') == 1) && (BufName != '-MiniBufExplorer-'))
            
              let l:found = l:found + 1
  
          endif
        endif
      endif
    endif
  endwhile

  let &report  = l:save_rep
  let &showcmd = l:save_sc

  call <SID>DEBUG('HasEligibleBuffers found '.l:found.' eligible buffers of '.l:needed.' needed',6)

  return (l:found >= l:needed)
  
endfunction

" }}}
" Auto Update Check - Function called by auto commands to see if MBE needs to
" be updated {{{
" If current buffer's modified flag has changed THEN
" call the auto update function. ELSE
" Don't do anything
" This is implemented to save resources so that MBE does not have to update
" on every keypress to check if the buffer has been modified
let g:modTrackingList = []
function! <SID>AutoUpdateCheck(currBuf)
    let l:bufAlreadyExists = 0
    for item in g:modTrackingList
        if (item[0] == a:currBuf)
            let l:bufAlreadyExists = 1
            if(getbufvar(a:currBuf, '&modified') != item[1])
                call <SID>AutoUpdate(-1,bufnr(a:currBuf))
                "update g:modTrackingList with new &mod flag state
                "call <SID>DEBUG(getbufvar(a:currBuf, '&modified'),1)
                let item[1] = getbufvar(a:currBuf, '&modified')
            elseif(getbufvar(a:currBuf, '&modified') == item[1])
                "do nothing
            endif
        endif
    endfor
    if (l:bufAlreadyExists == 0)
        call add(g:modTrackingList, [a:currBuf,0])
    endif
    call <SID>DEBUG('Buffer List is '.join(g:modTrackingList),10)
endfunction

" }}}
" Clean Mod Tracking List - Function called when a buffer is deleted to keep the
" list used to track modified buffers nice and small {{{
" On buffer delete, loop through g:modTrackingList and delete the item that
" matches this buffer's number
function! <SID>CleanModTrackingList(currBuf)
    let l:trackingListPos = 0
    for item in g:modTrackingList
        if (item[0] == a:currBuf)
            call <SID>DEBUG('Buffer index to be deleted is '.l:trackingListPos,10)
            call remove(g:modTrackingList, l:trackingListPos)
        endif
        let l:trackingListPos = l:trackingListPos + 1
    endfor
endfunction

" }}}
" Auto Update - Function called by auto commands for auto updating the MBE {{{
"
" IF auto update is turned on        AND
"    we are in a real buffer         AND
"    we have enough eligible buffers THEN
" Update our explorer and get back to the current window
"
" If we get a buffer number for a buffer that 
" is being deleted, we need to make sure and 
" remove the buffer from the list of eligible 
" buffers in case we are down to one eligible
" buffer, in which case we will want to close
" the MBE window.
"
function! <SID>AutoUpdate(delBufNum,currBufName)
  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Entering AutoUpdate('.a:delBufNum.') : '.bufnr('%').' : '.bufname('%'),10)
  call <SID>DEBUG('===========================',10)

  if (g:miniBufExplInAutoUpdate == 1)
    call <SID>DEBUG('AutoUpdate recursion stopped',9)
    call <SID>DEBUG('===========================',10)
    call <SID>DEBUG('Terminated AutoUpdate()'    ,10)
    call <SID>DEBUG('===========================',10)
    return
  else
    let g:miniBufExplInAutoUpdate = 1
  endif

  " Don't bother autoupdating the MBE window, and skip the FuzzyFinder window
  " (Thanks toupeira!)
  if (bufname('%') == '-MiniBufExplorer-' || bufname('%') == '[fuf]' || bufname('%') == '')
    " If this is the only buffer left then toggle the buffer
    if (winbufnr(2) == -1)
        call <SID>CycleBuffer(1)
        if g:miniBufExplForceSyntaxEnable
            call <SID>DEBUG('Enable Syntax', 9)
            exec 'syntax enable'
        endif
        call <SID>DEBUG('AutoUpdate does not run for cycled windows', 9)
    else
      call <SID>DEBUG('AutoUpdate does not run for the MBE window', 9)
    endif

    call <SID>DEBUG('===========================',10)
    call <SID>DEBUG('Terminated AutoUpdate()'    ,10)
    call <SID>DEBUG('===========================',10)

    let g:miniBufExplInAutoUpdate = 0
    return

  endif

  call <SID>MRUPush(bufnr("%"))
  
  if (a:delBufNum != -1)
    call <SID>DEBUG('AutoUpdate will make sure that buffer '.a:delBufNum.' is not included in the buffer list.', 5)
    call <SID>MRUPop(a:delBufNum)
  endif
  
  " Only allow updates when the AutoUpdate flag is set
  " this allows us to stop updates on startup.
  if g:miniBufExplorerAutoUpdate == 1
    " Only show MiniBufExplorer if we have a real buffer
    if ((g:miniBufExplorerMoreThanOne == 0) || (bufnr('%') != -1 && bufname('%') != ""))
      if <SID>HasEligibleBuffers(a:delBufNum) == 1
        " if we don't have a window then create one
        let l:bufnr = <SID>FindWindow('-MiniBufExplorer-', 0)
        if (l:bufnr == -1)
          call <SID>DEBUG('About to call StartExplorer (Create MBE)', 9)
          call <SID>StartExplorer(0, a:delBufNum, bufname("%"))
        else
        " otherwise only update the window if the contents have
        " changed
          let l:ListChanged = <SID>BuildBufferList(a:delBufNum, 0, a:currBufName)
          if (l:ListChanged)
            call <SID>DEBUG('About to call StartExplorer (Update MBE)', 9) 
            call <SID>StartExplorer(0, a:delBufNum, bufnr("%"))
          endif
        endif

        " go back to the working buffer
        if (bufname('%') == '-MiniBufExplorer-')
          wincmd p
        endif
      else
        call <SID>DEBUG('Failed in eligible check', 9)
        call <SID>StopExplorer(0)
      endif

	  " VIM sometimes turns syntax highlighting off,
	  " we can force it on, but this may cause weird
	  " behavior so this is an optional hack to force
	  " syntax back on when we enter a buffer
	  if g:miniBufExplForceSyntaxEnable
		call <SID>DEBUG('Enable Syntax', 9)
		exec 'syntax enable'
	  endif

    else
      call <SID>DEBUG('No buffers loaded...',9)
    endif
  else
    call <SID>DEBUG('AutoUpdates are turned off, terminating',9)
  endif

  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Completed AutoUpdate()'     ,10)
  call <SID>DEBUG('===========================',10)

  let g:miniBufExplInAutoUpdate = 0

endfunction

" }}}
" GetSelectedBuffer - From the MBE window, return the bufnum for buf under cursor {{{
" 
" If we are in our explorer window then return the buffer number
" for the buffer under the cursor.
"
function! <SID>GetSelectedBuffer()
  call <SID>DEBUG('Entering GetSelectedBuffer()',10)

  " Make sure we are in our window
  if bufname('%') != '-MiniBufExplorer-'
    call <SID>DEBUG('GetSelectedBuffer called in invalid window',1)
    return -1
  endif

  let l:save_reg = @"
  let @" = ""
  normal ""yi[
  if @" != ""
    let l:retv = substitute(@",'\([0-9]*\):.*', '\1', '') + 0
    let @" = l:save_reg
    return l:retv
  else
    let @" = l:save_reg
    return -1
  endif

endfunction

" }}}
" MBESelectBuffer - From the MBE window, open buffer under the cursor {{{
" 
" If we are in our explorer, then we attempt to open the buffer under the
" cursor in the previous window.
"
" Split indicates whether to open with split, 0 no split, 1 split horizontally
"
function! <SID>MBESelectBuffer(split)
  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Entering MBESelectBuffer()' ,10)
  call <SID>DEBUG('===========================',10)

  " Make sure we are in our window
  if bufname('%') != '-MiniBufExplorer-'
    call <SID>DEBUG('MBESelectBuffer called in invalid window',1)
    return 
  endif

  let l:save_rep = &report
  let l:save_sc  = &showcmd
  let &report    = 10000
  set noshowcmd 
  
  let l:bufnr  = <SID>GetSelectedBuffer()
  let l:resize = 0

  if(l:bufnr != -1)             " If the buffer exists.

    let l:saveAutoUpdate = g:miniBufExplorerAutoUpdate
    let g:miniBufExplorerAutoUpdate = 0
    " Switch to the previous window
    wincmd p

    " If we are in the buffer explorer or in a nonmodifiable buffer with
    " g:miniBufExplModSelTarget set then try another window (a few times)
    if bufname('%') == '-MiniBufExplorer-' || (g:miniBufExplModSelTarget == 1 && getbufvar(bufnr('%'), '&modifiable') == 0)
      wincmd w
      if bufname('%') == '-MiniBufExplorer-' || (g:miniBufExplModSelTarget == 1 && getbufvar(bufnr('%'), '&modifiable') == 0)
        wincmd w
        if bufname('%') == '-MiniBufExplorer-' || (g:miniBufExplModSelTarget == 1 && getbufvar(bufnr('%'), '&modifiable') == 0)
          wincmd w
          " The following handles the case where -MiniBufExplorer-
          " is the only window left. We need to resize so we don't
          " end up with a 1 or two line buffer.
          if bufname('%') == '-MiniBufExplorer-'
            let l:resize = 1
            new
          endif
        endif
      endif
    endif

    if a:split == 0
	exec('b! '.l:bufnr)
    elseif a:split == 1
	exec('sb! '.l:bufnr)
    elseif a:split == 2
	exec('vertical sb! '.l:bufnr)
    endif

    if (l:resize)
      resize
    endif
    let g:miniBufExplorerAutoUpdate = l:saveAutoUpdate
    call <SID>AutoUpdate(-1,bufnr("%"))

  endif

  let &report  = l:save_rep
  let &showcmd = l:save_sc

  if g:miniBufExplCloseOnSelect == 1
    call <SID>StopExplorer(1)
  endif

  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Completed MBESelectBuffer()',10)
  call <SID>DEBUG('===========================',10)
endfunction

" }}}
" MBEDeleteBuffer - From the MBE window, delete selected buffer from list {{{
" 
" After making sure that we are in our explorer, This will delete the buffer 
" under the cursor. If the buffer under the cursor is being displayed in a
" window, this routine will attempt to get different buffers into the 
" windows that will be affected so that windows don't get removed.
"
function! <SID>MBEDeleteBuffer(prevBufName)
  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Entering MBEDeleteBuffer()' ,10)
  call <SID>DEBUG('===========================',10)

  " Make sure we are in our window
  if bufname('%') != '-MiniBufExplorer-'
    call <SID>DEBUG('MBEDeleteBuffer called in invalid window',1)
    return 
  endif

  let l:curLine    = line('.')
  let l:curCol     = virtcol('.')
  let l:selBuf     = <SID>GetSelectedBuffer()
  let l:selBufName = bufname(l:selBuf)

  if l:selBufName == 'MiniBufExplorer.DBG' && g:miniBufExplorerDebugLevel > 0
    call <SID>DEBUG('MBEDeleteBuffer will not delete the debug window, when debugging is turned on.',1)
    return
  endif

  let l:save_rep = &report
  let l:save_sc  = &showcmd
  let &report    = 10000
  set noshowcmd 
  
  
  if l:selBuf != -1 

    " Don't want auto updates while we are processing a delete
    " request.
    let l:saveAutoUpdate = g:miniBufExplorerAutoUpdate
    let g:miniBufExplorerAutoUpdate = 0

    " Save previous window so that if we show a buffer after
    " deleting. The show will come up in the correct window.
    wincmd p
    let l:prevWin    = winnr()
    let l:prevWinBuf = winbufnr(winnr())

    call <SID>DEBUG('Previous window: '.l:prevWin.' buffer in window: '.l:prevWinBuf,5)
    call <SID>DEBUG('Selected buffer is <'.l:selBufName.'>['.l:selBuf.']',5)

    " If buffer is being displayed in a window then 
    " move window to a different buffer before 
    " deleting this one. 
    let l:winNum = (bufwinnr(l:selBufName) + 0)
    " while we have windows that contain our buffer
    while l:winNum != -1 
        call <SID>DEBUG('Buffer '.l:selBuf.' is being displayed in window: '.l:winNum,5)

        " move to window that contains our selected buffer
        exec l:winNum.' wincmd w'

        call <SID>DEBUG('We are now in window: '.winnr().' which contains buffer: '.bufnr('%').' and should contain buffer: '.l:selBuf,5)

        let l:origBuf = bufnr('%')
        call <SID>CycleBuffer(1)
        let l:curBuf  = bufnr('%')

        call <SID>DEBUG('Window now contains buffer: '.bufnr('%').' which should not be: '.l:selBuf,5)

        if l:origBuf == l:curBuf
            " we wrapped so we are going to have to delete a buffer 
            " that is in an open window.
            let l:winNum = -1
        else
            " see if we have anymore windows with our selected buffer
            let l:winNum = (bufwinnr(l:selBufName) + 0)
        endif
    endwhile

    " Attempt to restore previous window
    call <SID>DEBUG('Restoring previous window to: '.l:prevWin,5)
    exec l:prevWin.' wincmd w'

    " Try to get back to the -MiniBufExplorer- window 
    let l:winNum = bufwinnr(bufnr('-MiniBufExplorer-'))
    if l:winNum != -1
        exec l:winNum.' wincmd w'
        call <SID>DEBUG('Got to -MiniBufExplorer- window: '.winnr(),5)
    else
        call <SID>DEBUG('Unable to get to -MiniBufExplorer- window',1)
    endif
  
    " Delete the buffer selected.
    call <SID>DEBUG('About to delete buffer: '.l:selBuf,5)
    exec('silent! bd '.l:selBuf)

    let g:miniBufExplorerAutoUpdate = l:saveAutoUpdate 
    call <SID>DisplayBuffers(-1,a:prevBufName)
    call cursor(l:curLine, l:curCol)

  endif

  let &report  = l:save_rep
  let &showcmd = l:save_sc

  call <SID>DEBUG('===========================',10)
  call <SID>DEBUG('Completed MBEDeleteBuffer()',10)
  call <SID>DEBUG('===========================',10)

endfunction

" }}}
" MBEClick - Handle mouse double click {{{
"
function! s:MBEClick()
  call <SID>DEBUG('Entering MBEClick()',10)
  call <SID>MBESelectBuffer(0)
endfunction

"
" MBEDoubleClick - Double click with the mouse.
"
function! s:MBEDoubleClick()
  call <SID>DEBUG('Entering MBEDoubleClick()',10)
  call <SID>MBESelectBuffer(0)
endfunction

" }}}
" CycleBuffer - Cycle Through Buffers {{{
"
" Move to next or previous buffer in the current window. If there 
" are no more modifiable buffers then stay on the current buffer.
" can be called with no parameters in which case the buffers are
" cycled forward. Otherwise a single argument is accepted, if 
" it's 0 then the buffers are cycled backwards, otherwise they
" are cycled forward.
"
function! <SID>CycleBuffer(forward)

  " The following hack handles the case where we only have one
  " window open and it is too small
  let l:saveAutoUpdate = g:miniBufExplorerAutoUpdate
  if (winbufnr(2) == -1)
    resize
    let g:miniBufExplorerAutoUpdate = 0
  endif
  
  " Change buffer (keeping track of before and after buffers)
  let l:origBuf = bufnr('%')
  if (a:forward == 1)
    bn!
  else
    bp!
  endif
  let l:curBuf  = bufnr('%')

  " Skip any non-modifiable buffers, but don't cycle forever
  " This should stop us from stopping in any of the [Explorers]
  while getbufvar(l:curBuf, '&modifiable') == 0 && l:origBuf != l:curBuf
    if (a:forward == 1)
        bn!
    else
        bp!
    endif
    let l:curBuf = bufnr('%')
  endwhile

  let g:miniBufExplorerAutoUpdate = l:saveAutoUpdate
  if (l:saveAutoUpdate == 1)
    call <SID>AutoUpdate(-1,bufnr("%"))
  endif

endfunction

" }}}
" MRUPop - remove buffer from MRU list {{{
"
function! <SID>MRUPop(buf)
  call filter(s:MRUList, 'v:val != '.a:buf)
endfunction

" }}}
" MRUPush - add buffer to MRU list {{{
"
function! <SID>MRUPush(buf)
  if <SID>IgnoreBuffer(a:buf) == 1
    return
  endif

  " Remove the buffer number from the list if it already exists.
  call <SID>MRUPop(a:buf)

  " Add the buffer number to the head of the list.
  call insert(s:MRUList,a:buf)
endfunction


" }}}
" DEBUG - Display debug output when debugging is turned on {{{
"
" Thanks to Charles E. Campbell, Jr. PhD <cec@NgrOyphSon.gPsfAc.nMasa.gov> 
" for Decho.vim which was the inspiration for this enhanced debugging 
" capability.
"
function! <SID>DEBUG(msg, level)

  if g:miniBufExplorerDebugLevel >= a:level

    " Prevent a report of our actions from showing up.
    let l:save_rep    = &report
    let l:save_sc     = &showcmd
    let &report       = 10000
    set noshowcmd 

    " Debug output to a buffer
    if g:miniBufExplorerDebugMode == 0
        " Save the current window number so we can come back here
        let l:prevWin     = winnr()
        wincmd p
        let l:prevPrevWin = winnr()
        wincmd p

        " Get into the debug window or create it if needed
        call <SID>FindCreateWindow('MiniBufExplorer.DBG', 1, 0, 0)
    
        " Make sure we really got to our window, if not we 
        " will display a confirm dialog and turn debugging
        " off so that we won't break things even more.
        if bufname('%') != 'MiniBufExplorer.DBG'
            call confirm('Error in window debugging code. Dissabling MiniBufExplorer debugging.', 'OK')
            let g:miniBufExplorerDebugLevel = 0
        endif

        " Write Message to DBG buffer
        let res=append("$",s:debugIndex.':'.a:level.':'.a:msg)
        norm G
        "set nomodified

        " Return to original window
        exec l:prevPrevWin.' wincmd w'
        exec l:prevWin.' wincmd w'
    " Debug output using VIM's echo facility
    elseif g:miniBufExplorerDebugMode == 1
      echo s:debugIndex.':'.a:level.':'.a:msg
    " Debug output to a file -- VERY SLOW!!!
    " should be OK on UNIX and Win32 (not the 95/98 variants)
    elseif g:miniBufExplorerDebugMode == 2
        if has('system') || has('fork')
            if has('win32') && !has('win95')
                let l:result = system("cmd /c 'echo ".s:debugIndex.':'.a:level.':'.a:msg." >> MiniBufExplorer.DBG'")
            endif
            if has('unix')
                let l:result = system("echo '".s:debugIndex.':'.a:level.':'.a:msg." >> MiniBufExplorer.DBG'")
            endif
        else
            call confirm('Error in file writing version of the debugging code, vim not compiled with system or fork. Dissabling MiniBufExplorer debugging.', 'OK')
            let g:miniBufExplorerDebugLevel = 0
        endif
    elseif g:miniBufExplorerDebugMode == 3
        let g:miniBufExplorerDebugOutput = g:miniBufExplorerDebugOutput."\n".s:debugIndex.':'.a:level.':'.a:msg
    endif
    let s:debugIndex = s:debugIndex + 1

    let &report  = l:save_rep
    let &showcmd = l:save_sc

  endif

endfunc " }}}
" CheckForLastWindow - Quit Vim if :q is excecuted when no files are open {{{
function! <SID>CheckForLastWindow()
  " if the window is quickfix go on
  if &buftype=="quickfix"
    " if this window is last on screen quit without warning
    if winbufnr(2) == -1
      quit
    endif
  endif
endfunction " }}}

" vim:ft=vim:fdm=marker:ff=unix:nowrap:tabstop=4:shiftwidth=4:softtabstop=4:smarttab:shiftround:expandtab
