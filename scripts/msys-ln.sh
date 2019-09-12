#!/bin/sh

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
if [ "$#" -eq 2 -a "$1" == "-s" ]; then
    TARGET="$2"
    LINK=$(basename "$TARGET")
elif [ "$#" -eq 3 -a "$1" == "-s" ]; then
    TARGET="$2"
    LINK="$3"
else
    echo "this weak implementation only supports \`ln -s\`"
    exit
fi

if [ -d "$TARGET" ]; then
    MKLINK_OPTS="//d"
fi

TARGET=$(cygpath -w -a "$TARGET")
LINK=$(cygpath -w -a "$LINK")

echo "$TARGET"
echo "$LINK"
CURRENT_PATH=`pwd`
cscript //nologo $SCRIPT_PATH/run-elevated.js \
    cmd //c mklink $MKLINK_OPTS "$LINK" "$TARGET"
