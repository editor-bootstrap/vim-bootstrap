" ============================================================================
" File:        gundo.vim
" Description: vim global plugin to visualize your undo tree
" Maintainer:  Steve Losh <steve@stevelosh.com>
" License:     GPLv2+ -- look it up.
" Notes:       Much of this code was thiefed from Mercurial, and the rest was
"              heavily inspired by scratch.vim and histwin.vim.
"
" ============================================================================


"{{{ Init
if !exists('g:gundo_debug') && (exists('g:gundo_disable') || exists('loaded_gundo') || &cp)"{{{
    finish
endif
let loaded_gundo = 1"}}}
"}}}

"{{{ Misc
command! -nargs=0 GundoToggle call gundo#GundoToggle()
command! -nargs=0 GundoRenderGraph call gundo#GundoRenderGraph()
"}}}