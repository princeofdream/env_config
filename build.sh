#!/bin/bash -
#===============================================================================
#
#          FILE: build.sh
#
#         USAGE: ./build.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2018年05月06日 16时52分42秒
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

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
TOP_DIR=$SCRIPT_PATH

$TOP_DIR/scripts/install.sh $@



