#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f "$0"))

AUTH_SERVICE=`ps aux|grep AuthenMngService|grep -v grep`

if [[ $AUTH_SERVICE == "" ]]; then
	sudo $SCRIPT_PATH/AuthenMngService
fi

$SCRIPT_PATH/iNodeClient.sh


