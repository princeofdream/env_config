#!/bin/bash -
#===============================================================================
#
#          FILE: 1.sh
#
#         USAGE: ./1.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 11/26/2018 09:01:10 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                              # Treat unset variables as an error


SHELL_FOLDER=$(dirname $(readlink -f "$0"))
TOP_DIR=${SHELL_FOLDER}/..

PLUGIN_BASE_PATH=$TOP_DIR/vimfiles/base
FAKE_ROOT=$HOME/Environment/env_rootfs
BIN_PATH=$HOME/Environment/env_rootfs/bin

get_result()
{
	if [ $1 -ne 0 ]
	then
		echo "Build Error !"
		echo "exit!"
		exit 1
	fi
}

build_ycm()
{
	if [ ! -d $PLUGIN_BASE_PATH/YouCompleteMe ]
	then
		return 1
	fi

	echo "Building YouCompleteMe"
	cd $PLUGIN_BASE_PATH/YouCompleteMe
	if [ ! -f "$PLUGIN_BASE_PATH/YouCompleteMe/third_party/ycmd/ycm_core.so" ]
	then
		if [ -f "$HOME/Environment/env_rootfs/usr/local/bin/gcc" ]
		then
			sed -i "s#extra_cmake_args =#cmake_args.append( \'-DCMAKE_C_COMPILER=$BIN_PATH/gcc\' )\n  cmake_args.append( \'-DCMAKE_CXX_COMPILER=$BIN_PATH/g++\' )\n\n  extra_cmake_args =#g" $PLUGIN_BASE_PATH/YouCompleteMe/third_party/ycmd/build.py
		fi
		./install.py --all --system-libclang --clang-completer --clang-tidy --java-complete
		# ./install.py --all
		# ./install.py --clang-completer
	fi
	get_result $?
	# mkdir -p $PLUGIN_BASE_PATH/YouCompleteMe/ycm_build
	# cd $PLUGIN_BASE_PATH/YouCompleteMe/ycm_build
	# cmake -G "Unix Makefiles" . $PLUGIN_BASE_PATH/YouCompleteMe/third_party/ycmd/cpp \
		# -DPATH_TO_LLVM_ROOT=$HOME/Environment/env_rootfs
	# cmake --build . --target ycm_core --config Release

	cd $TOP_DIR
	wait
}

install_py_pkgs()
{
	PKG_LIST=" \
		ipython \
		ipykernel \
		Autopep8 \
		pylint \
		argparse \
	"

	echo "install python dep"
	for item in $PKG_LIST; do
		echo "pip[3] install $item"
		pip install $item
		pip3 install $item
	done
}

setup_vimproc ()
{
	if [  ! -d "$PLUGIN_BASE_PATH/vimproc" ]
	then
		return -1
	fi
	cd $PLUGIN_BASE_PATH/vimproc.vim
	make -j12
	cd $PLUGIN_BASE_PATH
}	# ----------  end of function setup_vimproc  ----------

## main

echo $PLUGIN_BASE_PATH
main_func()
{
	if [[ $1 == "" ]]; then
		install_py_pkgs
	elif [[ "$1" == "ycm" ]]; then
		build_ycm $@
	fi

	echo "install sucess!"
}

main_func $@

