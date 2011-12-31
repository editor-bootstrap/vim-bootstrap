for i in ~/.vim ~/.vimrc ~/.gvimrc; do [ -e $i ] && mv $i $i.old; done
git clone git://github.com/avelino/.vimrc.git ~/.vim
cd ~/.vim
ln -s ../.vimrc .vimrc
