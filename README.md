# vim-bootstrap

Vim Bootstrap is generator provides a simple method of generating a .vimrc configuration for vim

This is a basic distribution of vim plugins and tools intended to be run
on top of the latest MacVIM snapshot.

We (Carl and Yehuda) both use this distribution for our own use, and
welcome patches and contributions to help make it an effective way to
get started with vim and then use it productively for years to come.

At present, we are still learning to use vim ourselves, so you should
anticipate a period of rapid development while we get a handle on the
best tools for the job. So far, we have mostly integrated existing
plugins and tools, and we anticipate to continue doing so while also
writing our own plugins as appropriate.

In general, you can expect that the tools we use work well together and
that we have given careful thought to the experience of using MacVIM
with the tools in question. If you run into an issue using it, please
report an issue to the issue tracker.


## Pre-requisites

The distribution is designed to work with Vim >= 7.3.

* ctags on Mac OSX
```
brew install ctags
```
* exuberant-ctags on Linux
```
apt-get install exuberant-ctags xclip
```
* pyflakes (optionally for python bundles)
```
pip install flake8
```

## Commands

Commands | Descriptions
--- | ---
`<C-w>+arrows` | Navege via viewports
`:cd <path>` | Open path */path*
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
`F4` | List all class and method
`,d` | Go to the method definition
`,v` | Split vertical
`,h` | Split horizontal
`,f` | Search using grep
`Shit + k` | Open documentation
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
