#!/bin/sh


TOP=$(pwd)
BUNDLE_PATH=$TOP/vimfiles/bundle
FAKE_ROOT=$HOME/Environment/env_rootfs
BIN_PATH=$HOME/Environment/env_rootfs/bin

function get_result()
{
	if [ $1 -ne 0 ]
	then
		echo "Build Error !"
		echo "exit!"
		exit -1
	fi
}

function build_the_silver_searcher()
{
	if [ -d  $BUNDLE_PATH/the_silver_searcher ]
	then
		cd $BUNDLE_PATH/the_silver_searcher
		echo "Building the_silver_searcher"
		if [ "$1" == "clean" ]
		then
			make clean
		fi
		if [ -f ag ]
		then
			echo "ag exist, skip build!"
		else
			./build.sh
			get_result $?
		fi
		cp ag $BIN_PATH/
	else
		echo "Do not have plugin the_silver_searcher"
	fi
	cd $TOP
	wait
}

function build_ycm()
{
	if [ -d $BUNDLE_PATH/YouCompleteMe ]
	then
		cd $BUNDLE_PATH/YouCompleteMe
		echo "Building YouCompleteMe"
		./install.py --clang-completer
		# ./install.py --all
		get_result $?
	else
		echo "Do not have plugin YouCompleteMe"
	fi
	cd $TOP
	wait
}

function build_ack2()
{
	if [ -d $BUNDLE_PATH/ack2 ]
	then
		cd $BUNDLE_PATH/ack2
		echo "Building ack2"
		if [ "$1" == "clean" ]
		then
			make clean
		fi
		if [ -f ack222 ]
		then
			echo "ack exist, skip build!"
		else
			perl Makefile.PL
			make
			# make ack-standalone
			make install DESTDIR=$FAKE_ROOT
			get_result $?
		fi
	else
		echo "Do not have plugin YouCompleteMe"
	fi
	cd $TOP
	wait
}






## main

echo $BUNDLE_PATH

build_the_silver_searcher $1 $2
build_ycm $1 $2
build_ack2 $1 $2

echo "install sucess!"


