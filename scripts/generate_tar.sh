#!/bin/bash -
#===============================================================================
#
#          FILE: compact.sh
#
#         USAGE: ./compact.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2018年01月01日 21时47分11秒
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

REAL_PATH=$(dirname $(readlink -f "$0"))
TOP_DIR=$REAL_PATH/..

FILE_NAME="rc.tar.bz2"
TMP_FILE_NAME="tmp.tar"

Compress_vimfiles ()
{
	mv $TOP/vimfiles/bundle/YouCompleteMe ./YouCompleteMe
	tar jchf rc.tar.bz2 vimfiles/
	mv $TOP/YouCompleteMe $TOP/vimfiles/bundle/YouCompleteMe
}	# ----------  end of function Compress_vimfiles  ----------


Compress_part_vimfiles ()
{
	find ./vimfiles/ -maxdepth 1 -path ./vimfiles/bundle -prune -o -path ./vimfiles/ -o -print |awk -F, '{printf "\"%s\"\n",$1}'|xargs tar chf $TMP_FILE_NAME
	find ./vimfiles/bundle/ -maxdepth 1 -path ./vimfiles/bundle/YouCompleteMe -prune -o -path ./vimfiles/bundle/ -o -print |awk -F, '{printf "\"%s\"\n",$1}'|xargs tar rhf $TMP_FILE_NAME
	cat $TMP_FILE_NAME | bzip2 > $FILE_NAME
	rm $TMP_FILE_NAME
}	# ----------  end of function Compress_part_vimfiles  ----------


Compress_part_vimfiles $@



