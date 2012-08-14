for i in ~/.vim ~/.vimrc ~/.gvimrc; do [ -e $i ] && mv $i $i.old; done
git clone https://github.com/avelino/.vimrc.git ~/.vim
cd ~/.vim
mkdir ~/.vim/bundles/
git submodule init && git submodule update
cd ~/
ln -s ~/.vim/vimrc ~/.vimrc
