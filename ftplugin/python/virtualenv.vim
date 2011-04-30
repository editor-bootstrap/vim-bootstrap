" Filename:      virtualenv.vim
" Description:   Activate a python virtualenv within Vim.
" Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>

if exists("g:virtualenv_loaded")
    finish
endif

let g:virtualenv_loaded = 1

if !has('python')
    finish
endif

if !exists("g:virtualenv_stl_format")
    let g:virtualenv_stl_format = '[%n]'
endif

if !exists("g:virtualenv_directory")
    if isdirectory($WORKON_HOME)
        let g:virtualenv_directory = $WORKON_HOME
    else
        let g:virtualenv_directory = '~/.virtualenvs'
    endif
endif

let s:save_cpo = &cpo
set cpo&vim

command! -bar VirtualEnvList :call s:VirtualEnvList()
command! -bar VirtualEnvDeactivate :call s:VirtualEnvDeactivate()
command! -bar -nargs=? -complete=customlist,s:CompleteVirtualEnv VirtualEnvActivate :call s:VirtualEnvActivate(<q-args>)

function! s:Warn(message) "{{{1
    echohl WarningMsg | echo a:message | echohl None
endfunction

function! s:Error(message) "{{{1
    echohl ErrorMsg | echo a:message | echohl None
endfunction

function! s:CheckEnv() "{{{1
    if !isdirectory(g:virtualenv_directory)
        call s:Error('g:virtualenv_directory is not set or is not a directory')
        return 0
    endif
    return 1
endfunction

function! s:VirtualEnvActivate(name) "{{{1
    if !s:CheckEnv()
        return
    endif
    let name = a:name
    if len(name) == 0  "Figure out the name based on current file
        if isdirectory($PROJECT_HOME)
            let fn = expand('%:p')
            let pat = '^'.$PROJECT_HOME.'/'
            if fn =~ pat
                let name = fnamemodify(substitute(fn, pat, '', ''), ':h')
            endif
        endif
    endif
    if len(name) == 0  "Couldn't figure it out, so DIE
        call s:Error("No VirtualEnv name given")
        return
    endif
    let bin = g:virtualenv_directory.'/'.name.'/bin'
    let script = bin.'/activate_this.py'
    if !filereadable(script)
        call s:Error("'".name."' is not a valid virtualenv")
        return 0
    endif
    call s:VirtualEnvDeactivate()
    let g:virtualenv_path = $PATH
    let $PATH = bin.':'.$PATH
    python << EOF
import vim, sys
activate_this = vim.eval('l:script')
prev_sys_path = list(sys.path)
execfile(activate_this, dict(__file__=activate_this))
EOF
    let g:virtualenv_name = name
endfunction

function! s:VirtualEnvDeactivate() "{{{1
    python << EOF
import vim, sys
try:
    sys.path[:] = prev_sys_path
    del(prev_sys_path)
except:
    pass
EOF
    if exists('g:virtualenv_path')
        let $PATH = g:virtualenv_path
    endif
    unlet! g:virtualenv_name
    unlet! g:virtualenv_path
endfunction

function! s:VirtualEnvList() "{{{1
    for name in s:GetVirtualEnvs('')
        echo name
    endfor
endfunction

function! s:GetVirtualEnvs(prefix) "{{{1
    if !s:CheckEnv()
        return []
    endif
    let venvs = []
    for dir in split(glob(g:virtualenv_directory.'/'.a:prefix.'*'), '\n')
        if !isdirectory(dir)
            continue
        endif
        let fn = dir.'/bin/activate_this.py'
        if !filereadable(fn)
            continue
        endif
        call add(venvs, fnamemodify(dir, ':t'))
    endfor
    return venvs
endfunction

function! s:CompleteVirtualEnv(arg_lead, cmd_line, cursor_pos) "{{{1
    return s:GetVirtualEnvs(a:arg_lead)
endfunction

"}}}

let &cpo = s:save_cpo
