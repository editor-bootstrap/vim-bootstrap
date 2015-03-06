" Add Merlin to rtp
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" Set Merlin as Syntastic checker for OCaml
let g:syntastic_ocaml_checkers = ['merlin']
