"*****************************************************************************
"" Vundle core
"*****************************************************************************
set nocompatible

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle..."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
  let iCanHazVundle=0
endif

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'


"*****************************************************************************
"" Vundle install packages
"*****************************************************************************
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'wincent/Command-T'
Bundle 'vim-scripts/ZoomWin'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'bling/vim-airline'
Bundle 'airblade/vim-gitgutter'
Bundle 'Yggdroot/indentLine'
Bundle 'Shougo/neocomplcache.vim'

"" Snippets
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/vim-snippets"
Bundle 'garbas/vim-snipmate'

"" Color
Bundle 'tomasr/molokai'

"" Installing plugins the first time
if iCanHazVundle == 0
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :BundleInstall
endif


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Unleash all VIM power
set nocompatible

"" Fix backspace indent
set backspace=indent,eol,start

"" allow plugins by file type
filetype on
filetype plugin on
filetype indent on

"" Better modes.  Remeber where we are, support yankring
set viminfo=!,'100,\"100,:20,<50,s10,h,n~/.viminfo

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,.pyc,__pycache__
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|tox)$'
let g:ctrlp_user_command = "find %s -type f | grep -Ev '"+ g:ctrlp_custom_ignore +"'"
let g:ctrlp_use_caching = 0

"" Remember last location in file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
endif

"" Encoding
set bomb
set ttyfast
set binary

"" Directories for swp files
set nobackup
set nowritebackup
set noswapfile

set sh=/bin/sh

set fileformats=unix,dos,mac
set backspace=indent,eol,start
set showcmd
set shell=sh

highlight clear SpellBad
highlight SpellBad term=reverse cterm=underline


"*****************************************************************************
"" Visual Settigns
"*****************************************************************************
set background=dark
syntax on
set ruler
set number

"" Menus I like :-)
aunmenu Help.
aunmenu Window.
let no_buffers_menu=1
highlight BadWhitespace ctermbg=red guibg=red
colorscheme molokai

set mousemodel=popup
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

if &term =~ '256color'
  set t_ut=
endif

"" Disable the pydoc preview window for the omni completion
set completeopt-=preview

"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

"" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\ %{fugitive#statusline()}

let g:airline_theme = 'powerlineish'
let g:airline_enable_branch = 1
let g:airline_enable_syntastic = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cab W! w!
cab Q! q!
cab Wq wq
cab Wa wa
cab wQ wq
cab WQ wq
cab W w
cab Q q


"*****************************************************************************
"" Variables
"*****************************************************************************
"" Plugin: CamelCaseMotion, remove all mappings ',w', ',b' and ',e'
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

"" python support
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0

let html_no_rendering=1
let javascript_enable_domhtmlcss=1
let c_no_curly_error=1

let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'

"" NERDTree configuration
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 20

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

"" Command-T configuration
let g:CommandTMaxHeight=20

"" FindFile
let g:FindFileIgnore = ['*.o', '*.pyc', '*.py~', '*.obj', '.git', '*.rbc', '*/tmp/*', '__pycache__']

"" Flake8
let g:pep8_map='<leader>8'
let g:flake8_builtins="_,apply"
let g:flake8_ignore="E501,W293"
let g:flake8_max_line_length=79


"*****************************************************************************
"" Function
"*****************************************************************************
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
  set textwidth=79
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  noremap <buffer> <Leader>p :Mm <CR>
endfunction

function TrimWhiteSpace()
  let @*=line(".")
  %s/\s*$//e
  ''
:endfunction


"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart

"" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"" less
autocmd BufNewFile,BufRead *.less set filetype=less

"" txt
au BufRead,BufNewFile *.txt call s:setupWrapping()

"" md
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()
au BufNewFile,BufRead *.dartset filetype=dart shiftwidth=2 expandtab

"" make/cmake
au FileType make set noexpandtab
autocmd BufNewFile,BufRead CMakeLists.txt setlocal ft=cmake

"" Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79,99 formatoptions+=croq softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd BufRead,BufNewFile *.py,*pyw set shiftwidth=4
autocmd BufRead,BufNewFile *.py,*.pyw set expandtab
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/
autocmd BufNewFile *.py,*.pyw set fileformat=unix
autocmd BufWritePre *.py,*.pyw normal m`:%s/\s\+$//e``
autocmd BufRead *.py,*.pyw set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufNewFile,BufRead *.py_tmpl,*.cover setlocal ft=python

autocmd FileType python set omnifunc=pythoncomplete#Complete

"" Go
autocmd BufNewFile,BufRead *.go setlocal ft=go
autocmd FileType go setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

"" ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby

"" php
autocmd FileType php setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab

"" verilog
autocmd FileType verilog setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2

"" html
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2 setlocal ft=html
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,londonhtml,eruby,mako,haml,daml,css,tmpl setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType html,htmldjango,htmljinja,londonhtml,eruby,mako,haml,daml let b:closetag_html_style=1
""autocmd FileType html,xhtml,xml,eruby,mako,haml,daml source ~/.vim/bundle/closetag.vim/plugin/closetag.vim
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

"" C/Obj-C/C++
autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=79
autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=79
autocmd FileType objc setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=79

"" vim
autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
autocmd FileType vim setlocal foldenable foldmethod=marker

"" js
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 colorcolumn=79
autocmd BufNewFile,BufRead *.json setlocal ft=javascript
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

if has("gui_running")
  autocmd BufWritePre * :call TrimWhiteSpace()
endif

set autoread


"*****************************************************************************
"" Mappings
"*****************************************************************************
"" How do i plugin map
map <Leader>l <Plug>Howdoi

"" Chrome OS remap <C-w> (command close tab)
map <tab> <c-w>
map <tab><tab> <c-w><c-w>
map ,w <c-w>

"" Python
noremap <C-K> :!python<CR>
noremap <C-L> :!python %<CR>

"" Split
noremap <Leader>h :split<CR>
noremap <Leader>v :vsplit<CR>

"" Git
noremap <Leader>ga :!git add .<CR>
noremap <Leader>gc :!git commit -m '<C-R>="'"<CR>
noremap <Leader>gsh :!git push<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

"" NerdTree
noremap <Leader>n :NERDTreeToggle<CR>
noremap <Plug> :NERDTreeToggle<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
noremap <F3> :NERDTreeToggle<CR>

"" Tabs
noremap th :tabnext<CR>
noremap t] :tabnext<CR>
noremap tl :tabprev<CR>
noremap t[ :tabprev<CR>
noremap tn :new<CR>
noremap tc :tabclose<CR>
noremap td :tabclose<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" ctrlp
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
noremap ,b :CtrlPBuffer<CR>
noremap ,y <C-y><CR>
let g:ctrlp_map = ',e'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_prompt_mappings = {
    \ 'PrtBS()': ['<bs>', '<c-]>'],
    \ 'PrtDelete()': ['<del>'],
    \ 'PrtDeleteWord()': ['<c-w>'],
    \ 'PrtClear()': ['<c-u>'],
    \ 'PrtSelectMove("j")': ['<c-j>', '<down>'],
    \ 'PrtSelectMove("k")': ['<c-k>', '<up>'],
    \ 'PrtSelectMove("t")': ['<Home>', '<kHome>'],
    \ 'PrtSelectMove("b")': ['<End>', '<kEnd>'],
    \ 'PrtSelectMove("u")': ['<PageUp>', '<kPageUp>'],
    \ 'PrtSelectMove("d")': ['<PageDown>', '<kPageDown>'],
    \ 'PrtHistory(-1)': ['<c-n>'],
    \ 'PrtHistory(1)': ['<c-p>'],
    \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
    \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
    \ 'AcceptSelection("t")': ['<c-t>'],
    \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
    \ 'ToggleFocus()': ['<s-tab>'],
    \ 'ToggleRegex()': ['<c-r>'],
    \ 'ToggleByFname()': ['<c-d>'],
    \ 'ToggleType(1)': ['<c-f>', '<c-up>'],
    \ 'ToggleType(-1)': ['<c-b>', '<c-down>'],
    \ 'PrtExpandDir()': ['<tab>'],
    \ 'PrtInsert("c")': ['<MiddleMouse>', '<insert>'],
    \ 'PrtInsert()': ['<c-\>'],
    \ 'PrtCurStart()': ['<c-a>'],
    \ 'PrtCurEnd()': ['<c-e>'],
    \ 'PrtCurLeft()': ['<c-h>', '<left>', '<c-^>'],
    \ 'PrtCurRight()': ['<c-l>', '<right>'],
    \ 'PrtClearCache()': ['<F5>'],
    \ 'PrtDeleteEnt()': ['<F7>'],
    \ 'CreateNewFile()': ['<c-y>'],
    \ 'MarkToOpen()': ['<c-z>'],
    \ 'OpenMulti()': ['<c-o>'],
    \ 'PrtExit()': ['<esc>', '<c-c>', '<c-g>'],
    \ }

"" Bubble single lines
nnoremap <C-Up> [e
nnoremap <C-Down> ]e

"" Bubble multiple lines
vnoremap <C-Up> [egv
vnoremap <C-Down> ]egv

"" try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk

"" Tag Code Navigation
nnoremap <Leader>f :TagbarToggle<CR>

"" Find file
nnoremap <C-f> :FF<CR>
nnoremap <C-s> :FS<CR>
nnoremap <C-c> :FC .<CR>

"" Remove trailing whitespace on <leader>S
nnoremap <leader>:call TrimWhiteSpace()<cr>:let @/=''<CR>

"" Rope
noremap <leader>j :RopeGotoDefinition<CR>
noremap <leader>r :RopeRename<CR>

"" Copy/Paste/Cut
noremap YY "+y<CR>
noremap P "+gP<CR>
noremap XX "+x<CR>

"" TODO: Take a look at this
nnoremap :call MatchCaseTag()

"" Buffer nav
nmap <S-p> :bp<CR>
nmap <S-o> :bn<CR>
noremap ,z :bp<CR>
noremap ,q :bp<CR>
noremap ,x :bn<CR>
noremap ,w :bn<CR>

"" Close buffer
noremap ,d :bd<CR>

"" Clean search (highlight)
noremap <leader>\ :noh<CR>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" ctags
map <F8> :!/usr/local/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
map <leader>] g<c-]>

"" Open current line on GitHub
noremap ,o :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>
