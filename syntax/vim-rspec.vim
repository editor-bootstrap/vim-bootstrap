syntax match rspecHeader /^*/
syntax match rspecTitle /^\[.\+/
syntax match rspecOk /^+.\+/
syntax match rspecError /^-.\+/
syntax match rspecErrorDetail /^  \w.\+/
syntax match rspecErrorURL /^  \/.\+/
syntax match rspecNotImplemented /^#.\+/
syntax match rspecCode /^  \d\+:/

highlight link rspecHeader Type 
highlight link rspecTitle Identifier 
highlight link rspecOk    Tag
highlight link rspecError Error
highlight link rspecErrorDetail Constant
highlight link rspecErrorURL PreProc
highlight link rspecNotImplemented Todo
highlight link rspecCode Type 
