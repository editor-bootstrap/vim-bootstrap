for i in ~/.vim ~/.vimrc ~/.gvimrc; do [ -e $i ] && mv $i $i.old; done
git clone git@github.com:magnunleno/Avelino-s-vimrc.git ~/.vim
cd ~/
ln -s .vim/.vimrc .vimrc 
