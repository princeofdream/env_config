#!/bin/bash -
#===============================================================================
#
#          FILE: process_vim.sh
#
#         USAGE: ./process_vim.sh
#
#   DESCRIPTION: process vim env
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Li Jin (JamesL), lij1@xiaopeng.com
#  ORGANIZATION: XPeng
#       CREATED: 12/30/2019 10:34:24 AM
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error

## start general setup curent script env
## like script path, name etc.(source basic_env.sh may overwrite it)
cmd_readlink ()
{
   target_file=$1

   cd `dirname $target_file`
   target_file=`basename $target_file`

   # iterate down a (possible) chain of symlinks
   while [ -l "$target_file" ]
   do
       target_file=`readlink $target_file`
       cd `dirname $target_file`
       target_file=`basename $target_file`
   done

   # compute the canonicalized name by finding the physical path
   # for the directory we're in and appending the target file.
   phys_dir=`pwd -p`
   result=$phys_dir/$target_file
   echo $result
}  # ----------  end of function cmd_readlink  ----------

cmd_readlink="readlink -f"
$cmd_readlink $0 >/dev/null 2> /dev/null
if [[ $? != 0 ]]; then
   cmd_readlink="cmd_readlink"
fi

#########################################
## TODO
## define new parameters here
#########################################
script_basename=$(basename $0)
script_path=$(dirname $($cmd_readlink "$0"))

## get current script path/name
if [[ ${top_dir}"x" == "x" ]]; then
	top_dir=${script_path}/..
fi

source ${top_dir}/scripts/basic_env.sh
#########################################
## TODO
## define overwrite parameters here
#########################################

## end of general setup curent script env

vim_dest_path=$top_dir/vimfiles
tmux_dest_path=$top_dir/tmux-config
env_base_dest_path=$top_dir/env_base


plugin_base_path=$top_dir/vimfiles/base
fake_root=$HOME/Environment/env_rootfs
bin_path=$HOME/Environment/env_rootfs/bin

vim_install_config()
{
	echo "=========== vim_install_config ==============="
	replace_config $top_dir/vimfiles $HOME/.vim
	# replace_config $top_dir/.vimrc $HOME/.vimrc
	if [[ -f $HOME/.vimrc ]]; then
		rm -rf $HOME/.vimrc
	fi

	replace_config $top_dir/ycm_extra_conf.py $HOME/.ycm_extra_conf.py
	replace_config $top_dir/configs/vim/ctags_lang $HOME/.ctags

	## for nvim
	replace_config $top_dir/vimfiles/init.vim $HOME/.config/nvim/init.vim
}

vim_setup_vundle_env ()
{
	vim_dest_path=$top_dir/vimfiles
	plugins_base_path=$vim_dest_path/bundle
	if [[ ! -d "$plugins_base_path" ]]; then
		mkdir -p $plugins_base_path
	fi

	cd $plugins_base_path
	if [ ! -d "$plugins_base_path/vundle.vim/" ]; then
		echo "$plugins_base_path/vundle.vim not exist! cloning from github..."
		git clone https://github.com/vundlevim/vundle.vim
	fi

	echo "update vim-plugins."
	cd $top_dir
	# vim -u $vim_dest_path/vimrc.mini --cmd "set rtp=./vimfiles,\$vimruntime,./vimfiles/after" +pluginclean +pluginupdate +qall
	vim -u $vim_dest_path/vimrc.mini --cmd "set rtp=./vimfiles,\$vimruntime,./vimfiles/after" +pluginclean +pluginupdate

	vim_install_config
}	# ----------  end of function setup_vim_vundle_env  ----------

vim_setup_env ()
{
	should_quite=$1

	vim_dest_path=$top_dir/vimfiles
	vim_plug_get_packages $vim_dest_path ${should_quite}

	if [[ ! -e $vim_dest_path/autoload/plug.vim && -e $vim_dest_path/base/vim-plug/plug.vim ]]; then
		cp -r $vim_dest_path/base/vim-plug/plug.vim $vim_dest_path/autoload/
	fi

	vim_install_config
}	# ----------  end of function setup_vim_plug_env  ----------


tmux_install_config()
{
	log "=========== tmux_install_config ==============="
	## for tmux plugin manager
	replace_config $top_dir/tmux-config/tmux $HOME/.tmux
	replace_config $top_dir/tmux-config/tmux/tmux.conf $HOME/.tmux.conf
}

tmux_install_tpm_plugins ()
{
	log "install tpm plugins"
	tmux new -d -s __noop >/dev/null 2>&1 || true
	tmux set-environment -g tmux_plugin_manager_path "~/.tmux/plugins"
	"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
	tmux kill-session -t __noop >/dev/null 2>&1 || true
}	# ----------  end of function tmux_install_tpm_plugins  ----------

tmux_setup_env ()
{
	should_quite=$1

	vim_plug_get_packages $tmux_dest_path ${should_quite}

	tmux_install_config
	tmux_install_tpm_plugins
}	# ----------  end of function setup_tmux_env  ----------

env_base_install_config()
{
	echo "=========== install_env_config ==============="
	replace_config $top_dir/env_base/common.sh $HOME/.common.sh
	replace_config $top_dir/env_base/env_tools.sh $HOME/.env_tools.sh
	replace_config $top_dir/env_base/bashrc $HOME/.bashrc
	replace_config $top_dir/env_base/bashrc-extern.sh $HOME/.bashrc-extern.sh
	replace_config $top_dir/env_base/zshrc $HOME/.zshrc
	replace_config $top_dir/env_base/zshrc-extern.sh $HOME/.zshrc-extern.sh
	replace_config $top_dir/env_base/jamesl.zsh-theme $HOME/.oh-my-zsh/themes/jamesl.zsh-theme
	replace_config $top_dir/env_base/base/spaceship-prompt $HOME/.oh-my-zsh/themes/spaceship-prompt
	replace_config $top_dir/env_base/base/spaceship-prompt/spaceship.zsh-theme $HOME/.oh-my-zsh/themes/spaceship.zsh-theme

	replace_config $top_dir/env_base/base/oh-my-zsh $HOME/.oh-my-zsh
	## for ubuntu fonts
	replace_config $top_dir/env_base/base/fonts $HOME/.fonts/truetype
	## for powerline segment config
	replace_config $top_dir/configs/powerline-shell/config.json $HOME/.config/powerline-shell/config.json
	## for aria2
	who_am_i=$(whoami)
	cp $top_dir/configs/aria2/aria2.conf_org $top_dir/configs/aria2/aria2.conf_${who_am_i}
	if [[ $system_type == "mac" ]]; then
		sed -i "" "s/\$HOME/\/home\/$who_am_i/g" $top_dir/configs/aria2/aria2.conf_${who_am_i}
	else
		sed -i "s/\$HOME/\/home\/$who_am_i/g" $top_dir/configs/aria2/aria2.conf_${who_am_i}
	fi
	replace_config $top_dir/configs/aria2 $HOME/.config/aria2
}

env_base_setup_env ()
{
	should_quite=$1

	vim_plug_get_packages $env_base_dest_path ${should_quite}

	if [[ ! -d $HOME/.config ]]; then
		mkdir -p $HOME/.config
	fi

	init_git_config
	setup_powerline_shell
	env_base_install_config
}	# ----------  end of function setup_env_base  ----------

build_install_py_pkgs()
{
	PKG_LIST=" \
		ipython \
		ipykernel \
		Autopep8 \
		pylint \
		argparse \
	"

	log "install python dep"
	for item in $PKG_LIST; do
		log "pip[3] install $item"
		pip install $item
		pip3 install $item
	done
}

build_ycm()
{
	if [ ! -d $plugin_base_path/YouCompleteMe ]
	then
		return 1
	fi

	log "Building YouCompleteMe"
	cd $plugin_base_path/YouCompleteMe
	if [ ! -f "$plugin_base_path/YouCompleteMe/third_party/ycmd/ycm_core.so" ]
	then
		# if [ -f "$HOME/Environment/env_rootfs/usr/local/bin/gcc" ]
		# then
		#     sed -i "s#extra_cmake_args =#cmake_args.append( \'-DCMAKE_C_COMPILER=$BIN_PATH/gcc\' )\n  cmake_args.append( \'-DCMAKE_CXX_COMPILER=$BIN_PATH/g++\' )\n\n  extra_cmake_args =#g" $PLUGIN_BASE_PATH/YouCompleteMe/third_party/ycmd/build.py
		# fi
		if [[ -e ${plugin_base_path}/YouCompleteMe/third_party/ycmd/go ]]; then
			rm -rf ${plugin_base_path}/YouCompleteMe/third_party/ycmd/go
		fi
		./install.py --all --system-libclang --clang-completer --clang-tidy --java-complete
		# ./install.py --all
		# ./install.py --clang-completer
	fi
	# mkdir -p $plugin_base_path/YouCompleteMe/ycm_build
	# cd $plugin_base_path/YouCompleteMe/ycm_build
	# cmake -G "Unix Makefiles" . $plugin_base_path/YouCompleteMe/third_party/ycmd/cpp \
		# -DPATH_TO_LLVM_ROOT=$HOME/Environment/env_rootfs
	# cmake --build . --target ycm_core --config Release

	cd $top_dir
	wait
}

build_setup_env ()
{
	# build_install_py_pkgs $@
	build_ycm $@
}	# ----------  end of function build_setup_env  ----------

