" Add Merlin to rtp
let g:opamshare = substitute(system('opam var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" ale
:call extend(g:ale_linters, {
    \'ocaml': ['merlin'], })
