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


## Pre-requisites

The distribution is designed to work with Vim >= 7.3.


## Installation

  `curl https://raw.github.com/avelino/.vimrc/master/bootstrap.sh -o - | sh`

or

0. `for i in ~/.vim ~/.vimrc ~/.gvimrc; do [ -e $i ] && mv $i $i.old;
   done`
1. `git clone git://github.com/avelino/.vimrc.git ~/.vim`
2. `ln -s ~/.vim/.vimrc ~/.vimrc`


## Updating to the latest version

To update to the latest version of the distribution, just run `git pull`
again inside your `~/.vim` directory.
