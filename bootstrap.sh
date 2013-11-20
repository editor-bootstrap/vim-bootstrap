for i in ~/.vim ~/.vimrc ~/.gvimrc ~/.vimrc.local; do [ -e $i ] && mv $i $i.old; done
cd ~/
git clone https://github.com/avelino/.vimrc.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
cp ~/.vim/vimrc.local.example ~/.vim/.vimrc.local
ln -s ~/.vim/vimrc.local ~/.vimrc.local
