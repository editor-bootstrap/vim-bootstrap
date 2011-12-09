# Avelino's vim Distribution

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

## Installation

0. `for i in ~/.vim ~/.vimrc ~/.gvimrc; do [ -e $i ] && mv $i $i.old;
   done`
1. `git clone git://github.com/avelino/.vimrc.git ~/.vim`
2. `cd ~/.vim`
3. `cp .vimrc ../`

or

  `curl https://raw.github.com/avelino/.vimrc/master/bootstrap.sh -o - | sh`

## Updating to the latest version

To update to the latest version of the distribution, just run `rake`
again inside your `~/.vim` directory.

# Intro to VIM

Here's some tips if you've never used VIM before:

## All commands

* `:cd /path` Open folder
* `tn` Open new tab
* `te` Open new tab and load file
* `t]` Next tab
* `t[` Go to back tab
* `Ctrl+c` Add all file in cache for vim (recommended to run as an open project)
* `Ctrl+f` Find file and open active tab (need cache for vim)
* `Ctrl+s` Find file and open in new tab
* `\b` Open file in buffer vim
* `\d`, `\n` or `F3` Open explorer navegator
* `\f` List all class and function active file
* `\j` Go to definition method
* `\r` Rename all method
* `[e` Move active line to UP
* `e]` Move active line to DOWN
* `\v` or `Ctrl+w + v` Vertical Split
* `\h` or `Ctrl+w + s` Horizontal Spli
* `\w` or `Ctrl+w + q` Close current windows
* `Ctrl+k` Open python console
* `Ctrl+j` Run script python active open
* `\sh` Open shell
* `\p` Send source file to dpaste.com
* `\ga` Git add .
* `\gc` Git commit
* `\gsh` Git push
* `\gs` Git status
* `\gd` Git diff
* `\gr` Git remove




by github.com/carlhuda/janus
