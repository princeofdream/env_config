#!/bin/bash

export ORIGINAL_PATH=`pwd`
VIMFILES_PATH=$ORIGINAL_PATH/vimfiles
BUNDLE_PATH=$VIMFILES_PATH/bundle

WHOAMI=`whoami`

## for powerline-shell
cd $BUNDLE_PATH
cp ${ORIGINAL_PATH}/patch/*powerline-shell*.patch $BUNDLE_PATH/powerline-shell/
cd $BUNDLE_PATH/powerline-shell
if [ -d "segments" ]
then
	echo "Do reset!!!!!"
	rm -rf segments/idle.py segments/get_git_info.sh segments/info.sh segments/git_ext.py segments/android_prj.py segments/get_android_prj.sh
	rm -rf config.py*
	git reset --hard
	patch -p1 < 001-powerline-shell-change-color-and-add-idle.patch
	sed -i "s/\$WHOAMI/$WHOAMI/" segments/git_ext.py
	sed -i "s/\$WHOAMI/$WHOAMI/" segments/android_prj.py
	chmod a+x segments/get_git_info.sh
	chmod a+x segments/get_android_prj.sh
	python install.py
fi
cd ${ORIGINAL_PATH}

cp ./dist/ctags_lang ~/.ctags
cp .vimrc ~/.vimrc
cp .vimrc.plugins ~/.vimrc.plugins
cp .vimrc.local ~/.vimrc.local
cp .vimrc.plugins.local ~/.vimrc.plugins.local
rm -rf ~/.vim
cp -r vimfiles ~/.vim

cp .tmux.conf ~/
sed -i "s/\$WHOAMI/$WHOAMI/" ~/.tmux.conf
cp .bashrc ~/
cp .zshrc ~/
sed -i "s/\$WHOAMI/$WHOAMI/" ~/.zshrc
cp .bashrc ~/

echo "install DONE!"

