# vim-bootstrap

Vim Bootstrap is generator provides a simple method of generating a .vimrc configuration for vim, MacVim and GVim.

## Pre-requisites

The distribution is designed to work with Vim >= 7.3.

* ctags on Mac OSX
```
brew install ctags
```
* exuberant-ctags on Linux
```
apt-get install exuberant-ctags
```
* pyflakes (optionally for python bundles)
```
pip install flake8
```

## Commands

Commands | Descriptions
--- | ---
`<Control-w>+arrows` | Navegate via viewports
`:cd <path>` | Open path */path*
`,.` | Set path working directory
`SHIFT+o` | Next buffer navegate
`SHIFT+p` | previous buffer navegate
`SHIFT+t` | Create a tab
`TAB` | next tab navegate
`SHIFT+TAB` | previous tab navegate
`,e` | Find and open files
`,b` | Find file on buffer (open file)
`,c` | Close active buffer (clone file)
`F2`  | Open three navegate in actual opened file
`F3`  | Open/Close three navegate files
`F4` | List all class and method, support for python, go, ruby and php
`,v` | Split vertical
`,h` | Split horizontal
`,f` | Search using grep
`,o` | Open github file/line (website), if used git in **github**
`,ga` | git add **.**
`,gc` | git commit -m
`,gsh` | git push
`,gs` | git status
`,gb` | git blame
`,gd` | git diff
`,gr` | git remove
`>` | indent to right
`<` | indent to left
`gc` | Comment or uncomment lines that {motion} moves over

## Python hotkeys

Commands | Descriptions
--- | ---
`SHIFT+k` | Open documentation
`Control+Space` | Autocomplete
`,d` | Go to the Class/Method definition
`,r` | Rename object definition
`,n` | Show where command is usage

## Installation

* Download your own vimrc file at http://www.vim-bootstrap.com
* Put your vimrc file into home folder
```
mv ~/Downloads/vimrc ~/.vimrc
```
* Execute ViM and it will install plugins automatically
```
vim +qall
```

## Updating to the latest version

    :NeoBundleUpdate
