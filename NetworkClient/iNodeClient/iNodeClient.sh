#!/bin/sh
SCRIPT_PATH=$(dirname $(readlink -f "$0"))
CHK_LCALL=`echo $LC_ALL|grep ^zh_CN`
if [ "$CHK_LCALL" != "" ];then
    export LC_ALL=zh_CN.gb2312
fi

CHK_LANG=`echo $LANG|grep ^zh_CN`
if [ "$CHK_LANG" != "" ];then
    export LANG=zh_CN.gb2312
fi

cd $SCRIPT_PATH
sudo nohup $SCRIPT_PATH/AuthenMngService &
wait


"$SCRIPT_PATH/.iNode/iNodeClient" &


