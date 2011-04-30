"pigraph theme based on blackdust
"fmeyer@pigraph.com


set background=dark
hi clear          

if exists("syntax_on")
  syntax reset
endif

hi Boolean         guifg=#eee689 
hi Character       guifg=#eee689 
hi Comment         guifg=#7f7f7f
hi Condtional      guifg=#8fffff
hi Constant        guifg=#eee689 gui=none
hi Cursor          guifg=#000000 guibg=#aeaeae
hi Debug           guifg=#eee689 
hi Define          guifg=#83b1d4 
hi Delimiter       guifg=#8f8f8f
hi DiffAdd         guibg=#613c46
hi DiffChange      guibg=#333333
hi DiffDelete      guifg=#333333 guibg=#464646 gui=none
hi DiffText        guifg=#ffffff guibg=#1f1f1f 
hi Directory       guifg=#ffffff 
hi Error           guifg=#000000 guibg=#00ffff
hi ErrorMsg        guifg=#000000 guibg=#00c0cf
hi Exception       guifg=#8fffff gui=underline
hi Float           guifg=#9c93b3
hi FoldColumn      guifg=#eee689 guibg=#464646
hi Folded          guifg=#eee689 guibg=#333333
hi Function        guifg=#d38e63
hi Identifier      guifg=#ffffff
hi Include         guifg=#ee8a37 
hi IncSearch       guifg=#000000 guibg=#b1d631
hi Keyword         guifg=#ffffff 
hi Label           guifg=#8fffff gui=underline
hi Macro           guifg=#ee8a37 
hi MatchParen      guifg=#d0ffc0 guibg=#202020  ctermfg=157 ctermbg=237 cterm=bold
hi ModeMsg         guifg=#eee689 
hi MoreMsg         guifg=#ffffff 
hi NonText         guifg=#1f1f1f
hi LineNr          guifg=#7f7f7f guibg=#343a3f
hi Normal          guifg=#d6dbdf guibg=#2c3237 gui=none
hi Number          guifg=#aca0a3
hi Operator        guifg=#ffffff
hi Pmenu 		       guifg=#ffffff guibg=#202020 ctermfg=255 ctermbg=238
hi PmenuSel 	     guifg=#000000 guibg=#b1d631 ctermfg=0 ctermbg=148
hi PreCondit       guifg=#dfaf8f 
hi PreProc         guifg=#ee8a37 
hi Question        guifg=#ffffff 
hi Repeat          guifg=#8fffff gui=underline
hi Search          guifg=#000000 guibg=#b1d631
hi SpecialChar     guifg=#eee689 
hi SpecialComment  guifg=#eee689 
hi Special         guifg=#7f7f7f
hi SpecialKey      guifg=#7e7e7e
hi Statement       guifg=#8fffff
hi StatusLine      guifg=#b1d631 guibg=#000000 
hi StatusLineNC    guifg=#333333 guibg=#cccccc
hi StorageClass    guifg=#ffffff 
hi String          guifg=#dbf0b3
hi Structure       guifg=#ffffff gui=underline
hi Tag             guifg=#eee689 
hi Title           guifg=#ffffff guibg=#333333 
hi Todo            guifg=#ffffff guibg=#000000 
hi Typedef         guifg=#ffffff gui=underline
hi Type            guifg=#ffffff 
hi VertSplit 	   guifg=#444444 guibg=#303030 gui=none ctermfg=238 ctermbg=238
hi Visual          guifg=#000000 guibg=#b1d631
hi VisualNOS       guifg=#343a3f guibg=#f18c96 gui=underline
hi WarningMsg      guifg=#ffffff guibg=#333333 
hi WildMenu        guifg=#000000 guibg=#eee689
