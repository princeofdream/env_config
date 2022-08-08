#!/bin/bash -
#===============================================================================
#
#          FILE: opengrok_index.sh
#
#         USAGE: ./opengrok_index.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 12/12/2018 10:05:29 AM
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

SRC_PATH=$HOME/envx/common_libx/debug_src_full/
OPENGROK_JAR_PATH=$HOME/envx/web_base/opengrok/lib/opengrok.jar
OPENGROK_DATA_PATH=$HOME/envx/web_base/opengrok/data/
OPENGROK_CONF_PATH=$HOME/envx/web_base/opengrok/etc/configuration.xml

if [[ $1 != "" ]]; then
	SRC_PATH=$1
fi
echo "java -jar $OPENGROK_JAR_PATH -P -S -v -s $SRC_PATH -d $OPENGROK_DATA_PATH -W $OPENGROK_CONF_PATH"
java -jar $OPENGROK_JAR_PATH -P -S -v -s $SRC_PATH -d $OPENGROK_DATA_PATH -W $OPENGROK_CONF_PATH


