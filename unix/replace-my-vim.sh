#!/bin/bash

export ORIGINAL_PATH=`pwd`
VIMFILES_PATH=$ORIGINAL_PATH/vimfiles
BUNDLE_PATH=$VIMFILES_PATH/bundle

WHOAMI=`whoami`

## for powerline-shell
cd $BUNDLE_PATH
cp ${ORIGINAL_PATH}/patch/*.patch $BUNDLE_PATH/powerline-shell/
cd $BUNDLE_PATH/powerline-shell
if [ -d "segments" ]
then
	echo "in $(pwd) Do reset!!!!!"


	rm -rf segments/idle.py segments/get_git_info.sh segments/info.sh segments/git_ext.py segments/android_prj.py segments/get_android_prj.sh
	rm -rf config.py*

	git reset --hard
	git checkout master
	git reset --hard
	git branch -D by_James
	git branch by_James
	git checkout by_James
	git am *.patch
	# git am 0001-powerline-shell-Segments-Add-Segments.patch
	# git am 0002-powerline-shell-Add-segment-git_branch.patch
	# git am 0003-powerline-shell-Fix-no-branch-mistake.patch

	#git reset --hard
	#patch -p1 < 0001-Segments-Add-Segments.patch

	sed -i "s/\$WHOAMI/$WHOAMI/" segments/git_ext.py
	sed -i "s/\$WHOAMI/$WHOAMI/" segments/android_prj.py
	sed -i "s/\$WHOAMI/$WHOAMI/" segments/git_branch.py
	chmod a+x segments/get_git_info.sh
	chmod a+x segments/get_android_prj.sh
	chmod a+x segments/get_git_branch.sh
	python install.py
fi
cd ${ORIGINAL_PATH}

cp vimfiles/bundle/vim_plugins/a.vim/plugin/ -r vimfiles/

cp ./dist/ctags_lang ~/.ctags
cp .vimrc ~/.vimrc
cp .vimrc.plugins ~/.vimrc.plugins
cp .vimrc.local ~/.vimrc.local
cp .vimrc.plugins.local ~/.vimrc.plugins.local
rm -rf ~/.vim
cp -r vimfiles ~/.vim

# cd ~/.vim/bundle/YouCompleteMe
# ./install.py --clang-completer
# # ./install.py --all
# cd $ORIGINAL_PATH

cp .tmux.conf ~/
sed -i "s/\$WHOAMI/$WHOAMI/" ~/.tmux.conf
cp .bashrc ~/
cp .zshrc ~/
sed -i "s/\$WHOAMI/$WHOAMI/" ~/.zshrc
cp .bashrc ~/

echo "install DONE!"

