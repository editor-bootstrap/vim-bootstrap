for i in ~/.vim ~/.vimrc ~/.gvimrc; do [ -e $i ] && mv $i $i.old; done
cd ~/
git clone https://github.com/avelino/.vimrc.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
