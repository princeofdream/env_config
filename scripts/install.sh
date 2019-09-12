#!/bin/bash -
#===============================================================================
#
#          FILE: plug_install.sh
#
#         USAGE: ./plug_install.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2018年04月24日 23时59分53秒
#      REVISION:  ---
#===============================================================================

# set -o nounset                              # Treat unset variables as an error

cmd_readlink ()
{
	TARGET_FILE=$1

	cd `dirname $TARGET_FILE`
	TARGET_FILE=`basename $TARGET_FILE`

	# Iterate down a (possible) chain of symlinks
	while [ -L "$TARGET_FILE" ]
	do
		TARGET_FILE=`readlink $TARGET_FILE`
		cd `dirname $TARGET_FILE`
		TARGET_FILE=`basename $TARGET_FILE`
	done

	# Compute the canonicalized name by finding the physical path
	# for the directory we're in and appending the target file.
	PHYS_DIR=`pwd -P`
	RESULT=$PHYS_DIR/$TARGET_FILE
	echo $RESULT
}	# ----------  end of function cmd_readlink  ----------

CMD_READLINK="readlink -f"
$CMD_READLINK $0 2> /dev/null
if [[ $? != 0 ]]; then
	CMD_READLINK="cmd_readlink"
fi

SCRIPT_PATH=$(dirname $($CMD_READLINK "$0"))
TOP_DIR=$SCRIPT_PATH/..
INSTALL_BASE_PATH=$TOP_DIR/common
PLUG_MANAGER_BASE_PATH=$TOP_DIR/common

source $SCRIPT_PATH/common.sh


patch_vim_plugins ()
{
	# DEST_PATH=`realpath $TOP_DIR/vimfiles/base/c-support/`
	# cd $DEST_PATH
	# CUR_PWD=`pwd`
	# CUR_PWD=`realpath $CUR_PWD`
	# if [[ $CUR_PWD == "$DEST_PATH" ]]; then
	#     git checkout $DEST_PATH
	#     patch -p1 < $TOP_DIR/patch/vimfiles/c-support/*.patch
	# fi
	echo "patch vim plugins"
}	# ----------  end of function patch_vim_plugins  ----------

setup_vim_vundle_env ()
{
	INSTALL_BASE_PATH=$TOP_DIR/vimfiles
	PLUGINS_BASE_PATH=$INSTALL_BASE_PATH/bundle
	if [[ ! -d "$PLUGINS_BASE_PATH" ]]; then
		mkdir -p $PLUGINS_BASE_PATH
	fi

	cd $PLUGINS_BASE_PATH
	if [ ! -d "$PLUGINS_BASE_PATH/Vundle.vim/" ]; then
		echo "$PLUGINS_BASE_PATH/Vundle.vim not exist! cloning from github..."
		git clone https://github.com/VundleVim/Vundle.vim
	fi

	echo "Update vim-plugins."
	cd $TOP_DIR
	# vim -u $INSTALL_BASE_PATH/vimrc.mini --cmd "set rtp=./vimfiles,\$VIMRUNTIME,./vimfiles/after" +PluginClean +PluginUpdate +qall
	vim -u $INSTALL_BASE_PATH/vimrc.mini --cmd "set rtp=./vimfiles,\$VIMRUNTIME,./vimfiles/after" +PluginClean +PluginUpdate

	install_vim_config
}	# ----------  end of function setup_vim_vundle_env  ----------


vim_plug_get_packages ()
{
	INSTALL_FILE_PATH=$1
	QUITE_AFTER_INSTALL=$2

	cd $TOP_DIR
	if [[ $QUITE_AFTER_INSTALL == "quite" ]]; then
		echo "vim -N -u $INSTALL_FILE_PATH/vimrc.ins \
			--cmd "set rtp=$PLUG_MANAGER_BASE_PATH/,$PLUG_MANAGER_BASE_PATH/base,$PLUG_MANAGER_BASE_PATH/after,\$VIMRUNTIME" +PlugClean +PlugUpdate +qall"
		vim -N -u $INSTALL_FILE_PATH/vimrc.ins \
			--cmd "set rtp=$PLUG_MANAGER_BASE_PATH/,$PLUG_MANAGER_BASE_PATH/base,$PLUG_MANAGER_BASE_PATH/after,\$VIMRUNTIME" +PlugClean +PlugUpdate +qall
	else
		echo "vim -N -u $INSTALL_FILE_PATH/vimrc.ins \
			--cmd "set rtp=$PLUG_MANAGER_BASE_PATH/,$PLUG_MANAGER_BASE_PATH/base,$PLUG_MANAGER_BASE_PATH/after,\$VIMRUNTIME" +PlugClean +PlugUpdate"
		vim -N -u $INSTALL_FILE_PATH/vimrc.ins \
			--cmd "set rtp=$PLUG_MANAGER_BASE_PATH/,$PLUG_MANAGER_BASE_PATH/base,$PLUG_MANAGER_BASE_PATH/after,\$VIMRUNTIME" +PlugClean +PlugUpdate
	fi
}	# ----------  end of function vim_plug_get_packages  ----------

setup_vim_plug_env ()
{
	INSTALL_BASE_PATH=$TOP_DIR/vimfiles
	vim_plug_get_packages $INSTALL_BASE_PATH
	if [[ ! -f $INSTALL_BASE_PATH/autoload/plug.vim && -f $INSTALL_BASE_PATH/base/vim-plug/plug.vim ]]; then
		cp -r $INSTALL_BASE_PATH/base/vim-plug/plug.vim $INSTALL_BASE_PATH/autoload/
	fi

	install_vim_config
	patch_vim_plugins
}	# ----------  end of function setup_vim_plug_env  ----------


setup_env_base ()
{
	INSTALL_BASE_PATH=$TOP_DIR/env_base
	# vim_plug_get_packages $INSTALL_BASE_PATH "quite"
	vim_plug_get_packages $INSTALL_BASE_PATH "quite"

	if [[ ! -d $HOME/.config ]]; then
		mkdir -p $HOME/.config
	fi

	check_git_config
	powerline_shell_setup
	install_env_config
}	# ----------  end of function setup_env_base  ----------


setup_tmux_env ()
{
	INSTALL_BASE_PATH=$TOP_DIR/tmux-config
	vim_plug_get_packages $INSTALL_BASE_PATH "quite"

	install_tmux_config
	install_tpm_plugins
}	# ----------  end of function setup_tmux_env  ----------

install_icon_theme ()
{
	# https://github.com/xenlism/wildfire
	git clone https://github.com/xenlism/wildfire.git
	# bash $TOP_DIR/xenlism_wildfire.sh
}	# ----------  end of function install_icon_theme  ----------

main_func ()
{
	SETUP_TYPE=$1
	echo "Setup $SETUP_TYPE"
	install_plug_manager
	if [[ $SETUP_TYPE == "vundle" ]]; then
		setup_vim_vundle_env $@
	elif [[ $SETUP_TYPE == "vim_plug" || $SETUP_TYPE == "vim" ]]; then
		setup_vim_plug_env $@
	elif [[ $SETUP_TYPE == "tmux" ]]; then
		setup_tmux_env $@
	elif [[ $SETUP_TYPE == "env" ]]; then
		setup_env_base $@
	elif [[ $SETUP_TYPE == "theme" ]]; then
		install_icon_theme $@
	fi
}	# ----------  end of function main_func  ----------

main_func $@

