" Vim color file
"
" Author: Thiago Avelino <thiagoavelinoster@gmail.com>
"

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

" Set environment to 256 colours
set t_Co=256

let colors_name = "flux"

if version >= 700
  hi CursorLine     guibg=#00000D ctermbg=16
  hi CursorColumn   guibg=#00000D ctermbg=16
  hi MatchParen     guifg=#77FF1D guibg=#00000D gui=bold ctermfg=118 ctermbg=16 cterm=bold
  hi Pmenu          guifg=#FFFFFF guibg=#323232 ctermfg=255 ctermbg=236
  hi PmenuSel       guifg=#FFFFFF guibg=#C4E665 ctermfg=255 ctermbg=185
endif

" Background and menu colors
hi Cursor           guifg=NONE guibg=#FFFFFF ctermbg=255 gui=none
hi Normal           guifg=#FFFFFF guibg=#00000D gui=none ctermfg=255 ctermbg=16 cterm=none
hi NonText          guifg=#FFFFFF guibg=#0F0F1C gui=none ctermfg=255 ctermbg=233 cterm=none
hi LineNr           guifg=#FFFFFF guibg=#191926 gui=none ctermfg=255 ctermbg=234 cterm=none
hi StatusLine       guifg=#FFFFFF guibg=#272E1E gui=italic ctermfg=255 ctermbg=235 cterm=italic
hi StatusLineNC     guifg=#FFFFFF guibg=#282835 gui=none ctermfg=255 ctermbg=235 cterm=none
hi VertSplit        guifg=#FFFFFF guibg=#191926 gui=none ctermfg=255 ctermbg=234 cterm=none
hi Folded           guifg=#FFFFFF guibg=#00000D gui=none ctermfg=255 ctermbg=16 cterm=none
hi Title            guifg=#C4E665 guibg=NONE	gui=bold ctermfg=185 ctermbg=NONE cterm=bold
hi Visual           guifg=#FF6981 guibg=#323232 gui=none ctermfg=204 ctermbg=236 cterm=none
hi SpecialKey       guifg=#E65BC0 guibg=#0F0F1C gui=none ctermfg=169 ctermbg=233 cterm=none
"hi DiffChange       guibg=#4C4C09 gui=none ctermbg=58 cterm=none
"hi DiffAdd          guibg=#252555 gui=none ctermbg=235 cterm=none
"hi DiffText         guibg=#66326D gui=none ctermbg=241 cterm=none
"hi DiffDelete       guibg=#3F0009 gui=none ctermbg=52 cterm=none
 
hi DiffChange       guibg=#4C4C09 gui=none ctermbg=234 cterm=none
hi DiffAdd          guibg=#252556 gui=none ctermbg=17 cterm=none
hi DiffText         guibg=#66326E gui=none ctermbg=22 cterm=none
hi DiffDelete       guibg=#3F000A gui=none ctermbg=0 ctermfg=196 cterm=none
hi TabLineFill      guibg=#5E5E5E gui=none ctermbg=235 ctermfg=228 cterm=none
hi TabLineSel       guifg=#FFFFD7 gui=bold ctermfg=230 cterm=bold


" Syntax highlighting
hi Comment guifg=#C4E665 gui=none ctermfg=185 cterm=none
hi Constant guifg=#E65BC0 gui=none ctermfg=169 cterm=none
hi Number guifg=#E65BC0 gui=none ctermfg=169 cterm=none
hi Identifier guifg=#7889B2 gui=none ctermfg=103 cterm=none
hi Statement guifg=#77FF1D gui=none ctermfg=118 cterm=none
hi Function guifg=#BBD7FE gui=none ctermfg=153 cterm=none
hi Special guifg=#C0C7FF gui=none ctermfg=153 cterm=none
hi PreProc guifg=#C0C7FF gui=none ctermfg=153 cterm=none
hi Keyword guifg=#77FF1D gui=none ctermfg=118 cterm=none
hi String guifg=#FF6981 gui=none ctermfg=204 cterm=none
hi Type guifg=#FED597 gui=none ctermfg=222 cterm=none
hi pythonBuiltin guifg=#7889B2 gui=none ctermfg=103 cterm=none
hi TabLineFill guifg=#662A3B gui=none ctermfg=237 cterm=none

