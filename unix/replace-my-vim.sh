#!/bin/bash

cp ./dist/ctags_lang ~/.ctags
cp .vimrc ~/.vimrc
cp .vimrc.plugins ~/.vimrc.plugins
cp .vimrc.local ~/.vimrc.local
cp .vimrc.plugins.local ~/.vimrc.plugins.local
rm -rf ~/.vim
cp -r vimfiles ~/.vim

cp .tmux.conf ~/
WHOAMI=`whoami`
sed -i "s/\$WHOAMI/$WHOAMI/" ~/.tmux.conf
cp .bashrc ~/
cp .zshrc ~/

# for powerline-shell
if [ -f "$HOME/.vim/bundle/powerline-shell/powerline-shell.py" ]
then
	ln -sf $HOME/.vim/bundle/powerline-shell/powerline-shell.py $HOME/powerline-shell.py
fi

