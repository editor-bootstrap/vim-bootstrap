" URL: https://github.com/whatyouhide/vim-hackerman
" Aurhor: Michele 'Ubik' De Simoni <ubik@ubik.tech>
" Version: 1.0.0
" License: MIT


" Bootstrap ===================================================================

hi clear
if exists('syntax_on') | syntax reset | endif
set background=dark
let g:colors_name = 'hackerman'


" Helper functions =============================================================

" Execute the 'highlight' command with a List of arguments.
function! s:Highlight(args)
  exec 'highlight ' . join(a:args, ' ')
endfunction

function! s:AddGroundValues(accumulator, ground, color)
  let new_list = a:accumulator
  for [where, value] in items(a:color)
    call add(new_list, where . a:ground . '=' . value)
  endfor

  return new_list
endfunction

function! s:Col(group, fg_name, ...)
  " ... = optional bg_name

  let pieces = [a:group]

  if a:fg_name !=# ''
    let pieces = s:AddGroundValues(pieces, 'fg', s:colors[a:fg_name])
  endif

  if a:0 > 0 && a:1 !=# ''
    let pieces = s:AddGroundValues(pieces, 'bg', s:colors[a:1])
  endif

  call s:Clear(a:group)
  call s:Highlight(pieces)
endfunction

function! s:Attr(group, attr)
  let l:attrs = [a:group, 'term=' . a:attr, 'cterm=' . a:attr, 'gui=' . a:attr]
  call s:Highlight(l:attrs)
endfunction

function! s:Clear(group)
  exec 'highlight clear ' . a:group
endfunction


" Colors ======================================================================

" Let's store all the colors in a dictionary.
let s:colors = {}

let s:colors.black        = { 'gui': '#080808', 'cterm': 232 }
let s:colors.white        = { 'gui': '#FFFFFF', 'cterm': 15 }
let s:colors.base7        = { 'gui': '#d3ebe9', 'cterm': 7 }
let s:colors.cyan         = { 'gui': '#00d7ff', 'cterm': 45 }
let s:colors.purple       = { 'gui': '#5f0087', 'cterm': 53 }
let s:colors.green        = { 'gui': '#00d700', 'cterm': 40 }
let s:colors.red          = { 'gui': '#800000', 'cterm': 1 }
let s:colors.orange       = { 'gui': '#ffaa00', 'cterm': 214 }
let s:colors.yellow       = { 'gui': '#ffff00', 'cterm': 226  }
let s:colors.pink         = { 'gui': '#d700af', 'cterm': 201 }
let s:colors.violet       = { 'gui': '#6f00ff', 'cterm': 57 }
let s:colors.blue         = { 'gui': '#133460', 'cterm': 23 }
let s:colors.gray         = { 'gui': '#969896', 'cterm': 246 }
let s:colors.darkergray   = { 'gui': '#1c1c1c', 'cterm': 233 }
let s:colors.base4        = { 'gui': '#245361', 'cterm': 23 }
let s:colors.base6        = { 'gui': '#99d1ce', 'cterm': 116 }

" Native highlighting ==========================================================

let s:background = 'black'

" This is the background colour of the line's number
let s:linenr_background = 'darkergray'

" Everything starts here.
call s:Col('Normal', 'cyan', s:background)

" Line, cursor and so on.
call s:Col('Cursor', 'blue', 'base7')
call s:Col('CursorLine', '', 'darkergray')
call s:Col('CursorColumn', '', 'black')

" Sign column, line numbers.
call s:Col('LineNr', 'cyan', s:linenr_background)
call s:Col('CursorLineNr', 'pink', s:linenr_background)
call s:Col('SignColumn', '', s:linenr_background)
call s:Col('ColorColumn', '', s:linenr_background)

" Visual selection.
call s:Col('Visual', '', 'blue')

" Easy-to-guess code elements.
call s:Col('Comment', 'gray')
call s:Col('String', 'green')
call s:Col('Number', 'orange')
call s:Col('Statement', 'pink')
call s:Col('Special', 'orange')
call s:Col('Identifier', 'pink')
call s:Col('Constant', 'orange')

" Some HTML tags (<title>, some <h*>s)
call s:Col('Title', 'pink')

" <a> tags.
call s:Col('Underlined', 'yellow')
call s:Attr('Underlined', 'underline')

" Types, HTML attributes.
call s:Col('Type', 'orange')

" Tildes on the bottom of the page.
call s:Col('NonText', 'base4')

" Concealed stuff.
call s:Col('Conceal', 'cyan', s:background)

" TODO and similar tags.
call s:Col('Todo', 'darkergray', s:background)

" The column separating vertical splits.
call s:Col('VertSplit', 'pink', s:linenr_background)
call s:Col('StatusLineNC', 'pink', 'blue')

" Matching parenthesis.
call s:Col('MatchParen', 'black', 'orange')

" Special keys, e.g. some of the chars in 'listchars'. See ':h listchars'.
call s:Col('SpecialKey', 'base4')

" Folds.
call s:Col('Folded', 'base6', 'blue')
call s:Col('FoldColumn', 'cyan', 'base4')

" Searching.
call s:Col('Search', 'blue', 'yellow')
call s:Attr('IncSearch', 'reverse')

" Popup menu.
call s:Col('Pmenu', 'base6', 'blue')
call s:Col('PmenuSel', 'base7', 'base4')
call s:Col('PmenuSbar', '', 'blue')
call s:Col('PmenuThumb', '', 'base4')

" Command line stuff.
call s:Col('ErrorMsg', 'red', 'black')
call s:Col('Error', 'red', 'black')
call s:Col('ModeMsg', 'blue')
call s:Col('WarningMsg', 'red')

" Wild menu.
" StatusLine determines the color of the non-active entries in the wild menu.
call s:Col('StatusLine', 'cyan', 'blue')
call s:Col('WildMenu', 'base7', 'cyan')

" The 'Hit ENTER to continue prompt'.
call s:Col('Question', 'green')

" Tab line.
call s:Col('TabLineSel', 'base7', 'blue')  " the selected tab
call s:Col('TabLine', 'base6', 'blue')     " the non-selected tabs
call s:Col('TabLineFill', 'black', 'black') " the rest of the tab line

" Spelling.
call s:Col('SpellBad', 'base7', 'red')
call s:Col('SpellCap', 'base7', 'blue')
call s:Col('SpellLocal', 'yellow')
call s:Col('SpellRare', 'base7', 'violet')

" Diffing.
call s:Col('DiffAdd', 'base7', 'green')
call s:Col('DiffChange', 'base7', 'blue')
call s:Col('DiffDelete', 'base7', 'red')
call s:Col('DiffText', 'base7', 'cyan')
call s:Col('DiffAdded', 'green')
call s:Col('DiffChanged', 'blue')
call s:Col('DiffRemoved', 'red')
call s:Col('DiffSubname', 'base4')

" Directories (e.g. netrw).
call s:Col('Directory', 'cyan')


" Programming languages and filetypes ==========================================

" Ruby.
call s:Col('rubyDefine', 'blue')
call s:Col('rubyStringDelimiter', 'green')

" HTML (and often Markdown).
call s:Col('htmlArg', 'blue')
call s:Col('htmlItalic', 'darkergray')
call s:Col('htmlBold', 'cyan', '')

" Python.
call s:Col('pythonAttribute', 'yellow')
call s:Col('pythonStatement', 'pink')
call s:Col('pythonInclude', 'red')
call s:Col('pythonFunction', 'yellow')
call s:Col('pythonBuiltin', 'blue')
call s:Col('pythonEscape', 'blue')




" Plugin =======================================================================

" GitGutter
call s:Col('GitGutterAdd', 'green', s:linenr_background)
call s:Col('GitGutterChange', 'cyan', s:linenr_background)
call s:Col('GitGutterDelete', 'orange', s:linenr_background)
call s:Col('GitGutterChangeDelete', 'darkergray', s:linenr_background)

" CtrlP
call s:Col('CtrlPNoEntries', 'base7', 'orange') " no entries
call s:Col('CtrlPMatch', 'green')               " matching part
call s:Col('CtrlPPrtBase', 'base4')             " '>>>' prompt
call s:Col('CtrlPPrtText', 'cyan')              " text in the prompt
call s:Col('CtrlPPtrCursor', 'base7')           " cursor in the prompt

" unite.vim
call s:Col('UniteGrep', 'base7', 'green')
let g:unite_source_grep_search_word_highlight = 'UniteGrep'


" Cleanup =====================================================================

unlet s:colors
unlet s:background
unlet s:linenr_background
