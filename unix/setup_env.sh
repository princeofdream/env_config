#!/bin/sh


TOP=`pwd`

cd $TOP/vimfiles/bundle/the_silver_searcher
if [ -f ag ]
then
	echo "ag exist, skip build!"
else
	./build.sh
	if [ $? -ne 0 ]
	then
		echo "Build the_silver_searcher Error !"
		echo "exit!"
		exit -1
	fi
fi
cp ag $HOME/Environment/env_rootfs/bin
cd $TOP



