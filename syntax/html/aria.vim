" Vim syntax file
" Language:	    WAI-ARIA
" Maintainer:	othree <othree@gmail.com>
" URL:		    http://github.com/othree/html5-syntax.vim
" Last Change:  2010-09-25
" License:      MIT
" Changes:      update to Draft 16 September 2010

" WAI-ARIA States and Properties
" http://www.w3.org/TR/wai-aria/states_and_properties
syn keyword htmlArg contained role

" Global States and Properties
syn match  htmlArg contained "\<aria-\(atomic\|busy\|controls\|describedby\)\>"
syn match  htmlArg contained "\<aria-\(disabled\|dropeffect\|flowto\|grabbed\)\>"
syn match  htmlArg contained "\<aria-\(haspopup\|hidden\|invalid\|label\)\>"
syn match  htmlArg contained "\<aria-\(labelledby\|live\|owns\|relevant\)\>"

" Widget Attributes
syn match  htmlArg contained "\<aria-\(autocomplete\|checked\|disabled\|expanded\)\>"
syn match  htmlArg contained "\<aria-\(haspopup\|hidden\|invalid\|label\)\>"
syn match  htmlArg contained "\<aria-\(level\|multiline\|multiselectable\|orientation\)\>"
syn match  htmlArg contained "\<aria-\(pressed\|readonly\|required\|selected\)\>"
syn match  htmlArg contained "\<aria-\(sort\|valuemax\|valuemin\|valuenow\|valuetext\|\)\>"

" Live Region Attributes
syn match  htmlArg contained "\<aria-\(atomic\|busy\|live\|relevant\|\)\>"

" Drag-and-Drop attributes
syn match  htmlArg contained "\<aria-\(dropeffect\|grabbed\)\>"

" Relationship Attributes
syn match  htmlArg contained "\<aria-\(activedescendant\|controls\|describedby\|flowto\|\)\>"
syn match  htmlArg contained "\<aria-\(labelledby\|owns\|posinset\|setsize\|\)\>"

