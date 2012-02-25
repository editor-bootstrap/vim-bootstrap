" Vim ftplugin file
" Language: Python
" Authors:  André Kelpe <efeshundertelf at googlemail dot com>
"           Romain Chossart <romainchossat at gmail dot com>
"           Matthias Vogelgesang
"           Ricardo Catalinas Jiménez <jimenezrick at gmail dot com>
"           Patches and suggestions from all sorts of fine people
"
" More info and updates at:
"
" http://www.vim.org/scripts/script.php?script_id=910
"
"
" This plugin integrates the Python documentation view and search tool pydoc
" into Vim. The plugin allows you to view the documentation of a Python
" module or class by typing:
"
" :Pydoc foo.bar.baz (e.g. :Pydoc re.compile)
"
" Or search a word (uses pydoc -k) in the documentation by typing:
"
" :PydocSearch foobar (e.g. :PydocSearch socket)
"
" Vim will split the current window to show the Python documentation found by
" pydoc (the buffer will be called '__doc__', Pythonic, isn't it ;-) ). The
" name may cause problems if you have a file with the same name, but usually
" this should not happen.
"
" pydoc.vim also allows you to view the documentation of the 'word' (see :help
" word) under the cursor by pressing <Leader>pw or the 'WORD' (see :help WORD)
" under the cursor by pressing <Leader>pW. This is very useful if you want to
" jump to the docs of a module or class found by 'PydocSearch' or if you want
" to see the docs of a module/class in your source code.
"
" The script is developed in GitHub at:
"
" http://github.com/fs111/pydoc.vim
"
"
" If you want to use the script and pydoc is not in your PATH, just put a
" line like this in your .vimrc:
"
" let g:pydoc_cmd = '/usr/bin/pydoc'
"
" If you want to open pydoc files in vertical splits or tabs, give the
" appropriate command in your .vimrc with:
"
" let g:pydoc_open_cmd = 'vsplit'
"
" or
"
" let g:pydoc_open_cmd = 'tabnew'
"
" The script will highlight the search term by default. To disable this behaviour
" put in your .vimrc:
"
" let g:pydoc_highlight=0
"
" pydoc.vim is free software; you can redistribute it and/or
" modify it under the terms of the GNU General Public License
" as published by the Free Software Foundation; either version 2
" of the License, or (at your option) any later version.
"
" Please feel free to contact me and follow me on twitter (@fs111).

" IMPORTANT: We don't use here the `exists("b:did_ftplugin")' guard becase we
" want to let the Python filetype script that comes with Vim to execute as
" normal.

" Don't redefine the functions if this ftplugin has been executed previously
" and before finish create the local mappings in the current buffer
if exists('*s:ShowPyDoc') && g:pydoc_perform_mappings
    call s:PerformMappings()
    finish
endif

if !exists('g:pydoc_perform_mappings')
    let g:pydoc_perform_mappings = 1
endif

if !exists('g:pydoc_highlight')
    let g:pydoc_highlight = 1
endif

if !exists('g:pydoc_cmd')
    let g:pydoc_cmd = 'pydoc'
endif

if !exists('g:pydoc_open_cmd')
    let g:pydoc_open_cmd = 'split'
endif

setlocal switchbuf=useopen
highlight pydoc cterm=reverse gui=reverse

function s:ShowPyDoc(name, type)
    if a:name == ''
        return
    endif

    if g:pydoc_open_cmd == 'split'
        let l:pydoc_wh = 10
    endif

    if bufloaded("__doc__")
        let l:buf_is_new = 0
        if bufname("%") == "__doc__"
            " The current buffer is __doc__, thus do not
            " recreate nor resize it
            let l:pydoc_wh = -1
        else
            " If the __doc__ buffer is open, jump to it
            silent execute "sbuffer" bufnr("__doc__")
            let l:pydoc_wh = -1
        endif
    else
        let l:buf_is_new = 1
        silent execute g:pydoc_open_cmd '__doc__'
        if g:pydoc_perform_mappings
            call s:PerformMappings()
        endif
    endif

    setlocal modifiable
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal syntax=man

    silent normal ggdG
    " Remove function/method arguments
    let s:name2 = substitute(a:name, '(.*', '', 'g' )
    " Remove all colons
    let s:name2 = substitute(s:name2, ':', '', 'g' )
    if a:type == 1
        execute  "silent read !" g:pydoc_cmd s:name2
    else
        execute  "silent read !" g:pydoc_cmd "-k" s:name2
    endif
    normal 1G

    if exists('l:pydoc_wh') && l:pydoc_wh != -1
        execute "silent resize" l:pydoc_wh
    end

    if g:pydoc_highlight == 1
        execute 'syntax match pydoc' "'" . s:name2 . "'"
    endif

    let l:line = getline(2)
    if l:line =~ "^no Python documentation found for.*$"
        if l:buf_is_new
            execute "bdelete!"
        else
            normal u
            setlocal nomodified
            setlocal nomodifiable
        endif
        redraw
        echohl WarningMsg | echo l:line | echohl None
    else
        setlocal nomodified
        setlocal nomodifiable
    endif
endfunction

" Mappings
function s:PerformMappings()
    nnoremap <silent> <buffer> <Leader>pw :call <SID>ShowPyDoc('<C-R><C-W>', 1)<CR>
    nnoremap <silent> <buffer> <Leader>pW :call <SID>ShowPyDoc('<C-R><C-A>', 1)<CR>
    nnoremap <silent> <buffer> <Leader>pk :call <SID>ShowPyDoc('<C-R><C-W>', 0)<CR>
    nnoremap <silent> <buffer> <Leader>pK :call <SID>ShowPyDoc('<C-R><C-A>', 0)<CR>

    " remap the K (or 'help') key
    nnoremap <silent> <buffer> K :call <SID>ShowPyDoc(expand("<cword>"), 1)<CR>
endfunction

if g:pydoc_perform_mappings
    call s:PerformMappings()
endif

" Commands
command -nargs=1 Pydoc       :call s:ShowPyDoc('<args>', 1)
command -nargs=* PydocSearch :call s:ShowPyDoc('<args>', 0)
