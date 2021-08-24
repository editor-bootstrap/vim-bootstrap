# vim-bootstrap

Vim Bootstrap provides a simple method for generating .vimrc configuration files for Vim, NeoVim, NeoVim-Qt, MacVim and GVim.

Want to generate your vim/neovim file? Access [here](https://vim-bootstrap.com/)!

<a href="https://www.producthunt.com/posts/vim-bootstrap?utm_source=badge-featured&utm_medium=badge&utm_souce=badge-vim-bootstrap" target="_blank"><img src="https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=303760&theme=light" alt="vim-bootstrap - Your configuration generator for Neovim/Vim | Product Hunt" style="width: 250px; height: 54px;" width="250" height="54" /></a>

## Pre-requisites

The distribution is designed to work with Vim >= 8 and neovim.

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

* Arch Linux via *pacman*
```
$ sudo pacman -S git ctags ncurses curl
```
* Fedora

```
$ sudo dnf install ncurses-devel git ctags-etags curl
```

* openSUSE
```
$ sudo zypper in ncurses-devel git ctags curl
```

### BSD

* FreeBSD via *packages collection*
```
# pkg install git p5-Parse-ExuberantCTags ncurses curl
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

### Rust

* [rls](https://github.com/rust-lang/rls#setup)

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Installation

* Download your own vimrc file at https://vim-bootstrap.com
* Put your vimrc file into home folder or `$XDG_CONFIG_HOME/nvim/init.vim` if you use NeoVim

**vim:** `mv ~/Downloads/generate.vim ~/.vimrc`

**neovim:** `mv ~/Downloads/generate.vim $XDG_CONFIG_HOME/nvim/init.vim`

* Execute ViM and it will install plugins automatically
```
`vim`
```

### Fast-installation by URL parameters

Vim-bootstrap generator can accept URL params via request as example below.

    curl 'https://vim-bootstrap.com/generate.vim' --data 'editor=vim&frameworks=vuejs&langs=javascript&langs=php&langs=html&langs=ruby' > ~/.vimrc


### Updating to the latest version

    :VimBootstrapUpdate (thanks to @sherzberg)
    :PlugInstall


### Offline usage

You can run vim-bootstrap Go package to generate a vimrc file, just download it:

    go get github.com/editor-bootstrap/vim-bootstrap
    cd $GOPATH/src/github.com/editor-bootstrap/vim-bootstrap
    go build

Inside vim-bootrap folder `cd vim-bootstrap` use `vim-bootstrap` module (file) like this example:

    ./vim-bootstrap -langs=python,lua,ruby,javascript,haskell -frameworks vuejs -editor=vim > ~/.vimrc

For more instructions run `vim-bootstrap -h`

### openSUSE repo

vim-bootstrap is also available on openSUSE on both Leap 42.2/42.3 and Tumbleweed. Leap versions must add devel:tools repository before, while Tumbleweed users should have vim-bootstrap in the default repository without the need to add any extra repository.

* Leap 42.2
```
$ sudo zypper ar -f http://download.opensuse.org/repositories/devel:/tools/openSUSE_Leap_42.2/ devel:tools
$ sudo zypper ref
$ sudo zypper in vim-bootstrap
```

* Leap 42.3
```
$ sudo zypper ar -f http://download.opensuse.org/repositories/devel:/tools/openSUSE_Leap_42.3/ devel:tools
$ sudo zypper ref
$ sudo zypper in vim-bootstrap
```

* Tumbleweed
```
$ sudo zypper ref
$ sudo zypper in vim-bootstrap
```



## Customization

It's highly recommended to add customizations in a separate file. This way, you can maintain the original vim-bootstrap generated vimrc file and subsequent updates.

For Vim users, the files available for customization are `~/.vimrc.local` and `~/.vimrc.local.bundles`. The former handles general configuration while the latter handle external Vim plugins through `vim-plug`.

NeoVim users can also customize their configuration by using `$XDG_CONFIG_HOME/nvim/local_init.vim` and `$XDG_CONFIG_HOME/nvim/local_bundles.vim`.

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
<kbd>,</kbd><kbd>c</kbd> | Close active buffer (close file)
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
<kbd>Ctrl</kbd><kbd>h</kbd> | Does a fuzzy search in your command mode history
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

<details>
<summary>:black_small_square: Php hotkeys</summary>

Commands | Descriptions
-------- | -------
`,u`     | Include use statement
`,mm`    | Invoke the context menu
`,nn`    | Invoke the navigation menu
`,oo`    | Goto definition
`,oh`    | Goto definition on horizontal split
`,ov`    | Goto definition on vertical split
`,ot`    | Goto definition on tab
`,K`     | Show brief information about the symbol under the cursor
`,tt`    | Transform the classes in the current file
`,cc`    | Generate a new class (replacing the current file)
`,ee`    | Extract expression (normal mode)
`,ee`    | Extract expression (visual selection)
`,em`    | Extract method (visual selection)
`,pcd`   | cs-fixer fix directory
`,pcf`   | cs-fixer fix file

</details>

## Learn Vim

Visit the following sites to learn more about Vim:

* [Learn Vim Progressively](https://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/)
* [Vim Adventures](https://vim-adventures.com/)
* [Vimcasts](https://vimcasts.org)
* [Byte of Vim](https://www.swaroopch.com/notes/Vim)
* [MinuteVim Tricks](https://www.youtube.com/user/MinuteVimTricks)
* [Join the Church of Vim, and you too can be a saint!](https://www.avelino.run/church-vim)
* [Vim para noobs (in portuguese)](https://woliveiras.com.br/vimparanoobs/)
* [Vimbook (in portuguese)](https://cassiobotaro.gitbooks.io/vimbook/content/)
