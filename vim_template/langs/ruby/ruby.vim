let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

au BufNewFile,BufRead *.rb,*.rbw,*.gemspec set filetype=ruby
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
