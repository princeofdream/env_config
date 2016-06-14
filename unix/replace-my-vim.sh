#!/bin/bash

export ORIGINAL_PATH=`pwd`
VIMFILES_PATH=$ORIGINAL_PATH/vimfiles
BUNDLE_PATH=$VIMFILES_PATH/bundle


## for powerline-shell
cd $BUNDLE_PATH
cp ${ORIGINAL_PATH}/patch/powerline-shell.patch $BUNDLE_PATH/powerline-shell/
cd $BUNDLE_PATH/powerline-shell
rm -rf segments/idle.py
git reset --hard
patch -p1 < powerline-shell.patch
python install.py
cd ${ORIGINAL_PATH}

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


