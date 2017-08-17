#!/bin/bash

export TOP=`pwd`
VIMFILES_PATH=$TOP/vimfiles
BUNDLE_PATH=$VIMFILES_PATH/bundle

WHOAMI=`whoami`

## for powerline-shell
cd $BUNDLE_PATH
cp ${TOP}/patch/powerline-shell/*.patch $BUNDLE_PATH/powerline-shell/
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

    if [ "$WHOAMI" == "root" ]
    then
	    sed -i "s/\/home\/\$WHOAMI/\/$WHOAMI/" segments/git_ext.py
	    sed -i "s/\/home\/\$WHOAMI/\/$WHOAMI/" segments/android_prj.py
	    sed -i "s/\/home\/\$WHOAMI/\/$WHOAMI/" segments/git_branch.py
    else
	    sed -i "s/\/home\/\$WHOAMI/\/home\/$WHOAMI/" segments/git_ext.py
	    sed -i "s/\/home\/\$WHOAMI/\/home\/$WHOAMI/" segments/android_prj.py
	    sed -i "s/\/home\/\$WHOAMI/\/home\/$WHOAMI/" segments/git_branch.py
    fi
	chmod a+x segments/get_git_info.sh
	chmod a+x segments/get_android_prj.sh
	chmod a+x segments/get_git_branch.sh
	python install.py
fi
cd ${TOP}

cp vimfiles/bundle/vim_plugins/a.vim/plugin/ -r vimfiles/

if [ -e $HOME/.vim ]
then
	echo "Backing up $HOME/.vim"
	rm -rf $HOME/.vim_bk
	mv $HOME/.vim $HOME/.vim_bk
fi

if [ -e $HOME/.vimrc ]
then
	echo "Backing up $HOME/.vimrc"
	mv $HOME/.vimrc $HOME/.vimrc_bk
fi

if [ -e $HOME/.exvim ]
then
	echo "Remove $HOME/.exvim"
	rm -rf $HOME/.exvim*
fi

if [ -e $HOME/.ctags ]
then
	echo "Backing up $HOME/.ctags"
	mv $HOME/.ctags $HOME/.ctags_bk
fi

ln -s $TOP/dist/ctags_lang  $HOME/.ctags
ln -s $TOP/vimfiles $HOME/.exvim
ln -s $HOME/.exvim $HOME/.vim


if [ -e $HOME/.tmux.conf ]
then
	echo "Backing up $HOME/.tmux.conf"
	mv $HOME/.tmux.conf $HOME/.tmux.conf_bk
fi
if [ -e $HOME/.bashrc ]
then
	echo "Backing up $HOME/.bashrc"
	mv $HOME/.bashrc $HOME/.bashrc_bk
fi
if [ -e $HOME/.zshrc ]
then
	echo "Backing up $HOME/.zshrc"
	mv $HOME/.zshrc $HOME/.zshrc_bk
fi

cp $TOP/.tmux.conf $HOME/.tmux.conf
cp $TOP/.bashrc $HOME/.bashrc
cp $TOP/.zshrc $HOME/.zshrc


if [ "$WHOAMI" == "root" ]
then
    sed -i "s/\/home\/\$WHOAMI/\/$WHOAMI/" $HOME/.tmux.conf
    sed -i "s/\/home\/\$WHOAMI/\/$WHOAMI/" $HOME/.zshrc
else
    sed -i "s/\/home\/\$WHOAMI/\/home\/$WHOAMI/" $HOME/.tmux.conf
    sed -i "s/\/home\/\$WHOAMI/\/home\/$WHOAMI/" $HOME/.zshrc
fi
echo "install DONE!"

