#!/bin/sh
SHELL_FOLDER=$(dirname $(readlink -f "$0"))
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
cscript //nologo $SHELL_FOLDER/run-elevated.js \
    cmd //c mklink $MKLINK_OPTS "$LINK" "$TARGET"
