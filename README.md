# vim-bootstrap

[![Join the chat at https://gitter.im/avelino/vim-bootstrap](https://badges.gitter.im/avelino/vim-bootstrap.svg)](https://gitter.im/avelino/vim-bootstrap?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Vim Bootstrap is generator provides a simple method of generating a .vimrc configuration for vim, NeoVim, NeoVim-Qt, MacVim and GVim.

## Pre-requisites

The distribution is designed to work with Vim >= 7.4.

### Mac OSX

```
$ brew install git ctags
```

### Linux

* Ubuntu\Debian

```
$ sudo apt-get install git exuberant-ctags ncurses-term curl
```

* Gentoo
```
$ sudo emerge --ask dev-util/ctags sys-libs/ncurses dev-vcs/git dev-python/pyflakes net-misc/curl
```

* Arch Linux via *pacman* (recomend used *pacaur*)
```
$ sudo pacman -S git-core ctags ncurses curl
```
* Fedora

```
$ sudo dnf install ncurses-devel git ctags-etags curl
```

### Python bundle (optionally)

* pyflakes
* jedi
* neovim (neovim only) 

```
$ pip install flake8 jedi
$ pip2 install --user --upgrade neovim
$ pip3 install --user --upgrade neovim
```

### Elm bundle (optionally)

* elm-test
* elm-oracle
* elm-format

```
$ npm install -g elm-test
$ npm install -g elm-oracle
$ npm install -g elm-format@exp

```

## Installation

* Download your own vimrc file at http://www.vim-bootstrap.com
* Put your vimrc file into home folder or `$XDG_CONFIG_HOME/nvim/init.vim` if you use NeoVim

**vim:** `mv ~/Downloads/generate.vim ~/.vimrc`

**neovim:** `mv ~/Downloads/generate.vim $XDG_CONFIG_HOME/nvim/init.vim`

* Execute ViM and it will install plugins automatically
```
vim +PlugInstall +qall
```

### Fast-installation by URL parameters

Vim-bootstrap generator can accept URL params via request as example below.

    curl 'http://vim-bootstrap.com/generate.vim' --data 'langs=javascript&langs=php&langs=html&langs=ruby&editor=vim' > ~/.vimrc


### Updating to the latest version

    :VimBootstrapUpdate (thanks to @sherzberg)
    :PlugInstall


### Offline usage

You can run vim-bootstrap Go package to generate a vimrc file, just download it:

    go get github.com/avelino/vim-bootstrap
    cd $GOPATH/src/github.com/avelino/vim-bootstrap
    git submodule init
    git submodule update
    go build

Inside vim-bootrap folder `cd vim-bootstrap` use `vim-bootstrap` module (file) like this example:

    ./vim-bootstrap -langs=python,lua,ruby,javascript,haskell -editor=vim > ~/.vimrc

For more instructions run `vim-bootstrap -h`


## Customization

It's highly recommended to add customizations in a separate file. This way, you can maintain the original vim-bootstrap generated vimrc file and subsequent updates.

For Vim users, the files available for customization are `~/.vimrc.local` and `~/.vimrc.local.bundles`. The former handles general configuration while the latter handle external Vim plugins through `vim-plug`.

NeoVim users can also customize their configuration by using `$XDG_CONFIG_HOME/nvim/local_init.vim` and `$XDG_CONFIG_HOME/nvim/local_bundles.vim`.

## Plugins

Plugin | Description | Usage | Documentation
------------ | ------------- | ------------- | -------------
[NERDTree](https://github.com/scrooloose/nerdtree) | Tree explorer (think sidebar in Sublime) | F3 |
[NERDTree tabs](https://github.com/jistr/vim-nerdtree-tabs) | Allow NERDtree with tabs | | 
[vim-commentary](https://github.com/tpope/vim-commentary) | (Un)Comment lines | `gcc` (can do 3gcc to comment 3 lines) | 
[vim-fugitive](https://github.com/tpope/vim-fugitive) | a Git wrapper so awesome, it should be illegal | |
[vim-airline](https://github.com/vim-airline/vim-airline) | lean & mean status/tabline for vim that's light as air | |
[vim-gitgutter](https://github.com/airblade/vim-gitgutter) | shows a git diff in the 'gutter' (sign column) | |
[grep.vim](https://github.com/vim-scripts/grep.vim) | grep search tools integration with vim | :Grep <pattern> | 
[CSApprox](https://github.com/vim-scripts/CSApprox) | Make gvim-only colorschemes work transparently in terminal vim | |
[vim-trailing-whitespace](https://github.com/bronson/vim-trailing-whitespace) | Highlights trailing whitespace in red and provides :FixWhitespace to fix it.| :FixWhitespace |
[delimitMate](https://github.com/Raimondi/delimitMate) | provides insert mode auto-completion for quotes, parens, brackets, etc. | |
[tagbar](https://github.com/majutsushi/tagbar) | provides an easy way to browse the tags [i.e. ctags] of the current file and get an overview of its structure. | F4 |
[syntastic](https://github.com/vim-syntastic/syntastic) | Syntax checking hacks for vim | |
[indentLine](https://github.com/Yggdroot/indentLine) | displays thin vertical lines at each indentation level | |
[vim-bootstrap-updater](https://github.com/avelino/vim-bootstrap-updater) | Work in Progress? | |
[vim-polyglot](https://github.com/sheerun/vim-polyglot) | A solid language pack for Vim. (syntax highlighting) | |
[fzf](https://github.com/junegunn/fzf.vim) | A command line fuzzy finder | :FZF |
[vimproc.vim](https://github.com/Shougo/vimproc.vim) | Interactive command execution in vim (used for other plugins? https://github.com/Shougo/vimproc.vim/issues/83) | |
[vim-misc](https://github.com/xolox/vim-misc) | Miscellaneous auto-load Vim scripts | |
[vim-session](https://github.com/xolox/vim-session) | Extended session management for Vim (:mksession on steroids) | :SaveSession [name], :OpenSession |
[vimshell.vim](https://github.com/Shougo/vimshell.vim) | Powerful shell implemented by vim | :VimShell | https://github.com/Shougo/vimshell.vim/blob/master/doc/vimshell.txt
[ultisnips](https://github.com/SirVer/ultisnips) | The ultimate snippet solution for Vim | tab to autocomplete and jump forward, ctrl+b to jump back | https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt
[vim-snippets](https://github.com/honza/vim-snippets) | Snippets for ultisnips | |
[molokai](https://github.com/tomasr/molokai) | Molokai color scheme for Vim | |
[c.vim](https://github.com/vim-scripts/c.vim) | C/C++ IDE -- Write and run programs. Insert statements, idioms, comments etc.. | https://github.com/vim-scripts/c.vim/blob/master/doc/c-hotkeys.pdf
[split-manpage.vim](https://github.com/ludwig/split-manpage.vim) | View any man page in a split vim window (seems redundant with jedi-vim) | <Leader>+K while cursor is over a word |
[jedi-vim](https://github.com/davidhalter/jedi-vim) | Using the jedi autocompletion library for VIM | Ctrl+space |
[requirements.txt.vim](https://github.com/raimon49/requirements.txt.vim) | the Requirements File Format syntax support for Vim | |


## Commands
</summary>
<details>
<summary>:black_small_square: Basic Commands</summary>

Commands | Descriptions
--- | ---
`:cd <path>` | Open path */path*
<kbd>Ctrl</kbd><kbd>w</kbd>+<kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> | Navigate via split panels
<kbd>Ctrl</kbd><kbd>w</kbd><kbd>w</kbd> | Alternative navigate vim split panels
<kbd>,</kbd><kbd>.</kbd> | Set path working directory
<kbd>,</kbd><kbd>w</kbd> or <kbd>,</kbd><kbd>x</kbd> | Next buffer navigate
<kbd>,</kbd><kbd>q</kbd> or <kbd>,</kbd><kbd>z</kbd> | previous buffer navigate
<kbd>shift</kbd><kbd>t</kbd> | Create a tab
<kbd>tab</kbd> | next tab navigate
<kbd>shift</kbd><kbd>tab</kbd> | previous tab navigate
<kbd>,</kbd><kbd>e</kbd> | Find and open files
<kbd>,</kbd><kbd>b</kbd> | Find file on buffer (open file)
<kbd>,</kbd><kbd>c</kbd> | Close active buffer (clone file)
<kbd>F2</kbd>  | Open tree navigate in actual opened file
<kbd>F3</kbd>  | Open/Close tree navigate files
<kbd>F4</kbd> | List all class and method, support for python, go, lua, ruby and php
<kbd>,</kbd><kbd>v</kbd> | Split vertical
<kbd>,</kbd><kbd>h</kbd> | Split horizontal
<kbd>,</kbd><kbd>f</kbd> | Search in the project
<kbd>,</kbd><kbd>o</kbd> | Open github file/line (website), if used git in **github**
<kbd>,</kbd><kbd>s</kbd><kbd>h</kbd> | Open shell.vim terminal inside Vim or NeoVim built-in terminal
<kbd>,</kbd><kbd>g</kbd><kbd>a</kbd> | Execute *git add* on current file
<kbd>,</kbd><kbd>g</kbd><kbd>c</kbd> | git commit (splits window to write commit message)
<kbd>,</kbd><kbd>g</kbd><kbd>s</kbd><kbd>h</kbd> | git push
<kbd>,</kbd><kbd>g</kbd><kbd>l</kbd><kbd>l</kbd> | git pull
<kbd>,</kbd><kbd>g</kbd><kbd>s</kbd> | git status
<kbd>,</kbd><kbd>g</kbd><kbd>b</kbd> | git blame
<kbd>,</kbd><kbd>g</kbd><kbd>d</kbd> | git diff
<kbd>,</kbd><kbd>g</kbd><kbd>r</kbd> | git remove
<kbd>,</kbd><kbd>s</kbd><kbd>o</kbd> | Open Session
<kbd>,</kbd><kbd>s</kbd><kbd>s</kbd> | Save Session
<kbd>,</kbd><kbd>s</kbd><kbd>d</kbd> | Delete Session
<kbd>,</kbd><kbd>s</kbd><kbd>c</kbd> | Close Session
<kbd>></kbd> | indent to right
<kbd><</kbd> | indent to left
<kbd>g</kbd><kbd>c</kbd> | Comment or uncomment lines that {motion} moves over
<kbd>Y</kbd><kbd>Y</kbd> | Copy to clipboard
<kbd>,</kbd><kbd>p</kbd> | Paste
<kbd>Ctrl</kbd><kbd>y</kbd> + <kbd>,</kbd> | Activate Emmet plugin
</details>

<details>
<summary>:black_small_square: Python hotkeys</summary>

Commands | Descriptions
--- | ---
`SHIFT+k` | Open documentation
`Control+Space` | Autocomplete
`,d` | Go to the Class/Method definition
`,r` | Rename object definition
`,n` | Show where command is usage
</details>

<details>
<summary>:black_small_square: Ruby hotkeys</summary>

Commands | Descriptions
------- | -------
`,a`        | Run all specs
`,l`        | Run last spec
`,t`        | Run current spec
`,rap`        | Add Parameter
`,rcpc`     | Inline Temp
`,rel`        | Convert Post Conditional
`,rec`        | Extract Constant          (visual selection)
`,rec`       | Extract to Let (Rspec)
`,relv`     | Extract Local Variable    (visual selection)
`,rrlv`     | Rename Local Variable     (visual selection/variable under the cursor)
`,rriv`     | Rename Instance Variable  (visual selection)
`,rem`      | Extract Method            (visual selection)

</details>

## Learn Vim

Visit the following sites to learn more about Vim:

* [Learn Vim Progressively](http://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/)
* [Vim Adventures](http://vim-adventures.com/)
* [Vimcasts](http://vimcasts.org)
* [Using Vim as a Complete Ruby on Rails IDE](http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/)
* [Why, oh WHY, do those #?@! nutheads use vi?](http://www.viemu.com/a-why-vi-vim.html)
* [Byte of Vim](http://www.swaroopch.com/notes/Vim)
* [Screencast "17 tips for Vim" (in portuguese)](http://blog.lucascaton.com.br/?p=1081)
* [MinuteVim Tricks](https://www.youtube.com/user/MinuteVimTricks)
* [Join the Church of Vim, and you too can be a saint!](http://www.avelino.xxx/2015/03/church-vim)
* [Vim para noobs (in portuguese)](https://woliveiras.com.br/vimparanoobs/)
* [Vimbook (in portuguese)](https://cassiobotaro.gitbooks.io/vimbook/content/)
