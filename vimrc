"*****************************************************************************
"" Vundle Load
"*****************************************************************************
"{{{
" Load vundle
" no vi-compatible
set nocompatible

" Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle..."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
  let iCanHazVundle=0
endif

" required for vundle
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

"}}}


"*****************************************************************************
"" Vundle install packages
"*****************************************************************************
"{{{
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'wincent/Command-T'
Bundle 'kien/ctrlp.vim'
Bundle 'fs111/pydoc.vim'
Bundle 'vim-scripts/ZoomWin'
Bundle 'docunext/closetag.vim'
Bundle 'vim-scripts/django.vim'
Bundle 'avelino/london.vim'
Bundle 'vim-scripts/pytest.vim'
Bundle 'Soares/python.vim'
Bundle 'ervandew/supertab'
Bundle 'majutsushi/tagbar'
Bundle 'tpope/vim-fugitive'
Bundle 'avelino/flux.vim'
Bundle 'tomasr/molokai'
Bundle 'plasticboy/vim-markdown'
Bundle 'jg/bufexplorer'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'lunaru/vim-less'
Bundle 'mattn/zencoding-vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'nvie/vim-flake8'
Bundle 'rodjek/vim-puppet'
Bundle 'vim-scripts/pep8'
Bundle 'mileszs/ack.vim'
Bundle 'tomtom/tlib_vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'hynek/vim-python-pep8-indent'
Bundle 'vim-scripts/pylint.vim'
Bundle 'pyflakes.vim'
Bundle 'kevinw/pyflakes-vim'
Bundle 'rson/vim-conque'
Bundle 'fsouza/go.vim'
Bundle 'vim-scripts/Conque-Shell'
Bundle 'davidhalter/jedi-vim'
Bundle 'Yggdroot/indentLine'
Bundle 'qstrahl/vim-matchmaker'

Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/vim-snippets"
Bundle 'garbas/vim-snipmate'

" Installing plugins the first time
if iCanHazVundle == 0
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :BundleInstall
endif

" allow plugins by file type
filetype plugin on
filetype indent on
"}}}


"*****************************************************************************
"                                Basic Setup
"*****************************************************************************
"{{{
" Unleash all VIM power
set nocompatible

" Fix backspace indent
set backspace=indent,eol,start

filetype on
filetype plugin indent on

" Better modes.  Remeber where we are, support yankring
set viminfo=!,'100,\"100,:20,<50,s10,h,n~/.viminfo

" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" Enable hidden buffers
set hidden

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,.pyc,__pycache__
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" Remember last location in file
if has("autocmd")
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
endif

" GREP
set grepprg=ack

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set ttyfast
set binary

"Directories for swp files
set nobackup
set nowritebackup
set noswapfile

set sh=/bin/sh

set nocompatible
set fileformats=unix,dos,mac
set backspace=indent,eol,start
set showcmd
set shell=zsh

"}}}


"*****************************************************************************
"                              Visual Settigns
"*****************************************************************************
"{{{
" colorscheme, fonts, menus and etc
set background=dark
syntax on
set ruler
set number

" Menus I like :-)
" This must happen before the syntax system is enabled
aunmenu Help.
aunmenu Window.
let no_buffers_menu=1
set mousemodel=popup
highlight BadWhitespace ctermbg=red guibg=red
colorscheme molokai
set t_Co=256
set nocursorline
set guioptions=egmrt
set gfn=Monospace\ 8
if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif
endif

" Disable the pydoc preview window for the omni completion
set completeopt-=preview

" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

" Status bar
set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\ %{fugitive#statusline()}

"}}}


"*****************************************************************************
"                               Abbreviations
"*****************************************************************************
"{{{
" no one is really happy until you have this shortcuts
cab W! w!
cab Q! q!
cab Wq wq
cab Wa wa
cab wQ wq
cab WQ wq
cab W w
cab Q q
cab q qa

"}}}


"*****************************************************************************
"                                 Variables
"*****************************************************************************
"{{{
" Conf Avelino
let g:snips_author = "Thiago Avelino"

" python support
" --------------
"  don't highlight exceptions and builtins. I love to override them in local
"  scopes and it sucks ass if it's highlighted then. And for exceptions I
"  don't really want to have different colors for my own exceptions ;-)
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0

let html_no_rendering=1
let javascript_enable_domhtmlcss=1
let c_no_curly_error=1

let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'

" NERDTree configuration
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeShowBookmarks=1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

" Command-T configuration
let g:CommandTMaxHeight=20

" FindFile
let g:FindFileIgnore = ['*.o', '*.pyc', '*.py~', '*.obj', '.git', '*.rbc', '*/tmp/*', '__pycache__']

" miniBuf
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" Powerline
let g:Powerline_symbols = 'compatible'

" Flake8
let g:pep8_map='<leader>8'
let g:flake8_builtins="_,apply"
let g:flake8_ignore="E501,W293"
let g:flake8_max_line_length=99

"}}}


"*****************************************************************************
"                                  Function
"*****************************************************************************
"{{{
fun! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('')
    finally
       let &ic = ic
    endtry
endfun

function s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=99
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  noremap <buffer> <Leader>p :Mm <CR>
endfunction

" GUI Tab settings
function! GuiTabLabel()
    let label = ''
    let buflist = tabpagebuflist(v:lnum)
    if exists('t:title')
        let label .= t:title . ' '
    endif
    let label .= '[' . bufname(buflist[tabpagewinnr(v:lnum) - 1]) . ']'
    for bufnr in buflist
        if getbufvar(bufnr, '&modified')
            let label .= '+'
            break
        endif
    endfor
    return label
endfunction
set guitablabel=%{GuiTabLabel()}

" Removes trailing spaces
function TrimWhiteSpace()
  let @*=line(".")
  %s/\s*$//e
  ''
:endfunction

"}}}


"*****************************************************************************
"                               Autocmd Rules
"*****************************************************************************
"{{{
" Some minor or more generic autocmd rules
" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart
" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" less comprez
autocmd BufNewFile,BufRead *.less set filetype=less

if has("gui_running")
  autocmd BufWritePre * :call TrimWhiteSpace()
endif

" txt
au BufRead,BufNewFile *.txt call s:setupWrapping()
" make use real tabs
au FileType make set noexpandtab


"********** Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=99
      \ formatoptions+=croq softtabstop=4 smartindent
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
      \smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd BufRead,BufNewFile *.py,*pyw set shiftwidth=4
autocmd BufRead,BufNewFile *.py,*.pyw set expandtab
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/
autocmd BufNewFile *.py,*.pyw set fileformat=unix
autocmd BufWritePre *.py,*.pyw normal m`:%s/\s\+$//e``
autocmd BufRead *.py,*.pyw set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufNewFile,BufRead *.py_tmpl,*.cover setlocal ft=python
" code completion
autocmd FileType python set omnifunc=pythoncomplete#Complete

"********** Go
autocmd BufNewFile,BufRead *.go setlocal ft=go
autocmd FileType go setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

"********** PHP
autocmd FileType php setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab

"********** Verilog
autocmd FileType verilog setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2

"********** HTML
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2 setlocal ft=html
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,londonhtml,eruby,mako,haml,daml,css,tmpl setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType html,htmldjango,htmljinja,londonhtml,eruby,mako,haml,daml let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,eruby,mako,haml,daml source ~/.vim/bundle/closetag/plugin/closetag.vim
" code completion
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS


"********** C/Obj-C/C++
autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=99
autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=99
autocmd FileType objc setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=99

"********** vim
autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
autocmd FileType vim setlocal foldenable foldmethod=marker

"********** Javascript
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 colorcolumn=99
autocmd BufNewFile,BufRead *.json setlocal ft=javascript
" code completion
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

"********** Cmake
autocmd BufNewFile,BufRead CMakeLists.txt setlocal ft=cmake

"********** Ruby
" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

"********** Markdown
" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

"********** Markdown
au BufNewFile,BufRead *.dartset filetype=dart shiftwidth=2 expandtab


" Set auto reload file
set autoread

"}}}


"*****************************************************************************
"                                  Mappings
"*****************************************************************************
"{{{

" Python Execution
noremap <C-K> :!python<CR>
noremap <C-L> :!python %<CR>

" Split Screen
noremap <Leader>h :split<CR>
noremap <Leader>v :vsplit<CR>

" Git
noremap <Leader>ga :!git add .<CR>
noremap <Leader>gc :!git commit -m '<C-R>="'"<CR>
noremap <Leader>gsh :!git push<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

" ConqueTerm Shortcut
noremap <Leader>sh :ConqueTerm bash --login<CR>

" Paste to DPaste: http://dpaste.com/
noremap <Leader>p :Dpaste<CR>

" NerdTree shortcuts
noremap <Leader>n :NERDTreeToggle<CR>
noremap <Plug> :NERDTreeToggle<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
noremap <F3> :NERDTreeToggle<CR>

" ZoomWin configuration
noremap <Leader>z :ZoomWin<CR>

" BufExplorer configuration
nnoremap <leader>b :BufExplorer<cr>

" Tabs shortcuts
noremap th :tabnext<CR>
noremap t] :tabnext<CR>
noremap tl :tabprev<CR>
noremap t[ :tabprev<CR>
noremap tn :tabnew<CR>
noremap tc :tabclose<CR>
noremap td :tabclose<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" ctrlp
" Command mode: Ctrl+P
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
noremap ,b :CtrlPBuffer<CR>
let g:ctrlp_map = ',e'

" Bubble single lines
nnoremap <C-Up> [e
nnoremap <C-Down> ]e

" Bubble multiple lines
vnoremap <C-Up> [egv
vnoremap <C-Down> ]egv

" try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk

" Gundo Toggler
nnoremap <Leader>u :GundoToggle<CR>
noremap <leader>c :GundoToggle<CR>

" Tag Code Navigation
nnoremap <Leader>f :TagbarToggle<CR>

" Find file
nnoremap <C-f> :FF<CR>
nnoremap <C-s> :FS<CR>
nnoremap <C-c> :FC .<CR>

" Remove trailing whitespace on <leader>S
nnoremap <leader>:call TrimWhiteSpace()<cr>:let @/=''<CR>

" Rope
noremap <leader>j :RopeGotoDefinition<CR>
noremap <leader>r :RopeRename<CR>

" Grep
noremap <leader>g :Ack <C-R>=""<CR>
noremap <leader>b :b <C-R>=""<CR>

" Copy
noremap YY "+y<CR>

" Paste
noremap P "+gP<CR>

" Cut
noremap XX "+x<CR>

" TODO: Take a look at this
nnoremap   :call MatchCaseTag()

" Termnal nav
noremap <S-h> :bp<CR>
noremap <S-l> :bn<CR>
noremap ,z :bp<CR>
noremap ,x :bn<CR>

" Close buffer
noremap ,d :bd<CR>

" Clean search (highlight)
noremap <leader>\ :noh<CR>

" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" ctags
map <F8> :!/usr/local/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
map <leader>] g<c-]>

" Open current line on GitHub
noremap ,o :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>

"}}}
