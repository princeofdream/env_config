#!/bin/bash -
#===============================================================================
#
#          FILE: replace_config.sh
#
#         USAGE: ./replace_config.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 02/24/2018 04:07:45 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                              # Treat unset variables as an error

SCRIPT_PATH=$(dirname $(readlink -f "$0"))
if [[ $TOP_DIR == "" ]]; then
	TOP_DIR=${SCRIPT_PATH}/..
fi

if [[ $PLUG_MANAGER_BASE_PATH == "" ]]; then
	PLUG_MANAGER_BASE_PATH=$TOP_DIR/common
fi

SYSTEM_TYPE="Unkonw"

replace_config()
{
	SOURCE_FILE=$1
	TARGET_FILE=$2
	FORCE_REPLACE=$3

	TEST_REALPATH_CMD=`realpath >/dev/null 2>/dev/null`
	TEST_RET=$?
	if [ $TEST_RET -lt 127 ]
	then
		SOURCE_REAL_PATH=`realpath $SOURCE_FILE`
		TARGET_REAL_PATH=`realpath $TARGET_FILE`

		# echo "Source path <$SOURCE_FILE><$SOURCE_REAL_PATH> Target path <$TARGET_REAL_PATH>"

		if [ -e $SOURCE_FILE ]
		then
			if [ "$TARGET_REAL_PATH" == "$SOURCE_REAL_PATH" -a "$TARGET_REAL_PATH" != "" ]
			then
				echo "Target path <$TARGET_REAL_PATH> is the same as source, do nothing"
				return 0
			fi
		fi
	elif [[ $TEST_RET == 127 ]]; then
		echo "Do not have realpath!!"
	fi

	if [[ ! -d ${TARGET_FILE%'/'*} ]]; then
		mkdir -p ${TARGET_FILE%'/'*}
	fi

	if [ -e $TARGET_FILE ]
	then
		if [ -e "$TARGET_FILE"_bk ]
		then
			echo "Remove "$TARGET_FILE"_bk"
			rm -rf "$TARGET_FILE"_bk
		fi

		if [[ $FORCE_REPLACE == 1 ]]; then
			echo "Force Replace target file"
			echo "Delete $TARGET_FILE"
			rm -rf $TARGET_FILE
		else
			echo "Backing up $TARGET_FILE to "$TARGET_FILE"_bk"
			mv $TARGET_FILE "$TARGET_FILE"_bk
		fi
	fi

	if [ ! -e $SOURCE_FILE ]
	then
		echo "Do not have source file, Only backup target file"
		return 0
	fi
	echo "Createing $TARGET_FILE"
	if [[ "$SYSTEM_TYPE" == MSYS* || "$SYSTEM_TYPE" == MINGW* ]]
	then
		$SCRIPT_PATH/msys-ln.sh -s $SOURCE_FILE $TARGET_FILE
	else
		ln -sf $SOURCE_FILE $TARGET_FILE
	fi
}

check_git_config()
{
	echo "=========== check_git_config ==============="
	## check git config
	git_user_name=`git config --get user.name`
	git_user_email=`git config --get user.email`
	if [ "$git_user_name" == "" ]
	then
		 git config --global user.name "James Lee"
	fi

	if [ "$git_user_email" == "" ]
	then
		 git config --global user.email "princetemp@outlook.com"
	fi
	git config --global color.diff auto
	git config --global color.status auto
	git config --global color.branch auto
	git config --global color.interactive auto
}

powerline_shell_setup()
{
	echo "=========== powerline_shell_setup ==============="
	POWERLINE_SHELL_PATH=$TOP_DIR/env_base/base/powerline-shell
	cd $POWERLINE_SHELL_PATH
	rm -rf 0*.patch
	cp $SCRIPT_PATH/../patch/powerline-shell/*.patch $POWERLINE_SHELL_PATH

	get_branch=`git branch 2>/dev/null |grep '\*'`
	branch=${get_branch:2}
	git_remote_version=`git remote -v|grep fetch|awk '{printf $2}'`
	if [[ $git_remote_version != "https://github.com/milkbikis/powerline-shell.git" ]]; then
		echo "current git is not powerline-shell"
		return
	fi
	git reset --hard
	if [[ $branch == "byJames" ]]; then
		git checkout master
		git branch -D byJames
	fi
	git branch byJames
	git checkout byJames
	git am -3 *.patch

	python3 setup.py install
}

install_env_config()
{
	echo "=========== install_env_config ==============="
	replace_config $TOP_DIR/env_base/common.sh $HOME/.common.sh
	replace_config $TOP_DIR/env_base/env_tools.sh $HOME/.env_tools.sh
	replace_config $TOP_DIR/env_base/bashrc $HOME/.bashrc
	replace_config $TOP_DIR/env_base/bashrc-extern.sh $HOME/.bashrc-extern.sh
	replace_config $TOP_DIR/env_base/zshrc $HOME/.zshrc
	replace_config $TOP_DIR/env_base/zshrc-extern.sh $HOME/.zshrc-extern.sh
	replace_config $TOP_DIR/env_base/jamesl.zsh-theme $HOME/.oh-my-zsh/themes/jamesl.zsh-theme
	replace_config $TOP_DIR/env_base/base/spaceship-prompt $HOME/.oh-my-zsh/themes/spaceship-prompt
	replace_config $TOP_DIR/env_base/base/spaceship-prompt/spaceship.zsh-theme $HOME/.oh-my-zsh/themes/spaceship.zsh-theme

	replace_config $TOP_DIR/env_base/base/oh-my-zsh $HOME/.oh-my-zsh
	## for ubuntu fonts
	replace_config $TOP_DIR/env_base/base/fonts $HOME/.fonts/truetype
	## for powerline segment config
	replace_config $TOP_DIR/configs/powerline-shell/config.json $HOME/.config/powerline-shell/config.json
}

install_tmux_config()
{
	echo "=========== install_tmux_config ==============="
	## for tmux plugin manager
	replace_config $TOP_DIR/tmux-config/tmux $HOME/.tmux
	replace_config $TOP_DIR/tmux-config/tmux/tmux.conf $HOME/.tmux.conf
}


install_vim_config()
{
	echo "=========== install_vim_vundle_config ==============="
	replace_config $TOP_DIR/vimfiles $HOME/.vim
	replace_config $TOP_DIR/.vimrc $HOME/.vimrc

	replace_config $TOP_DIR/configs/vim/ycm_extra_conf.py $HOME/.ycm_extra_conf.py
	replace_config $TOP_DIR/configs/vim/ctags_lang $HOME/.ctags

	## for nvim
	replace_config $TOP_DIR/vimfiles/init.vim $HOME/.config/nvim/init.vim
}

install_tpm_plugins ()
{
	printf "Install TPM plugins\n"
	tmux new -d -s __noop >/dev/null 2>&1 || true
	tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
	"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
	tmux kill-session -t __noop >/dev/null 2>&1 || true
}	# ----------  end of function install_tpm_plugins  ----------

install_plug_manager ()
{
	echo "Check and install vim-plug to $PLUG_MANAGER_BASE_PATH."
	if [ ! -d "$PLUG_MANAGER_BASE_PATH" ]; then
		mkdir -p $PLUG_MANAGER_BASE_PATH
	fi
	cd $PLUG_MANAGER_BASE_PATH
	# download or update vundle in ./vimfiles/bundle/
	if [ ! -d "$PLUG_MANAGER_BASE_PATH/vim-plug" ]; then
		git clone https://github.com/junegunn/vim-plug.git
	fi

	sed -i "s/--depth 1//g" $PLUG_MANAGER_BASE_PATH/vim-plug/plug.vim
	sed -i "s/--depth 99999999/--unshallow/g" $PLUG_MANAGER_BASE_PATH/vim-plug/plug.vim
	sed -i "s/--depth 999999/--unshallow/g" $PLUG_MANAGER_BASE_PATH/vim-plug/plug.vim

	cp -rL $PLUG_MANAGER_BASE_PATH/vim-plug/plug.vim $PLUG_MANAGER_BASE_PATH/autoload/
}	# ----------  end of function install_plug_manager  ----------


