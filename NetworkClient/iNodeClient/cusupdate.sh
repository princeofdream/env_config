#!/bin/sh

INODE_CFG="/etc/iNode/inodesys.conf"
if [ -r "$INODE_CFG" ];then
    LINE=`cat $INODE_CFG`
    INSTALL_DIR=${LINE##*INSTALL_DIR=}
fi

if [ ! -r "/etc/iNodeTemp" ]
then
mkdir /etc/iNodeTemp
fi

cd $INSTALL_DIR
cp -r clientfiles/ /etc/iNodeTemp/clientfiles

OS_ROCKY=`cat /etc/issue | grep 'Rocky'`

if [ "$OS_ROCKY" != "" ]
then
    /etc/init.d/iNodeAuthService stop
    rm -f /etc/rc.d/rc3.d/S080iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc5.d/S080iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc0.d/K01iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc1.d/K01iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc2.d/K01iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc4.d/K01iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc6.d/K01iNodeAuthService > /dev/null 2>&1
else
    service iNodeAuthService stop
fi

Sec=0
while [ 1 ]
do
    IfExistMon=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeMon`
    if [ "$IfExistMon" != "" ]
    then
        sleep 1
        Sec=`expr $Sec + 1`

        if [ "$Sec" -lt 9 ]
	    then
            killall -9 iNodeMon > /dev/null 2>&1
        else
            killall -9 iNodeMon
            break
        fi
    else
        break
    fi
done

Sec=0
while [ 1 ]
do
    IfExistAuth=`ps awx -o command|awk -F/ '{print $NF}'|grep -x AuthenMngService`
    if [ "$IfExistAuth" != "" ]
    then
        sleep 1
        Sec=`expr $Sec + 1`

        if [ "$Sec" -lt 9 ]
		then
            killall -9 AuthenMngService > /dev/null 2>&1
        else
            killall -9 AuthenMngService
            break
        fi
    else
        break
    fi
done

IfExistUI=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeClient`
if [ "$IfExistUI" != "" ]
then
    sleep 5
    killall -9 iNodeClient
fi

INODE_CFG="/etc/iNode/inodesys.conf"
if [ -r "$INODE_CFG" ];then
    LINE=`cat $INODE_CFG`
    INSTALL_DIR=${LINE##*INSTALL_DIR=}
fi

rm -f ./custom/DeskIconLinux.png
rm -f ./custom/MainIcon.ico

cd $INSTALL_DIR
tar -xzvf iNodeCusUpd.tar.gz

if [ -r "./custom/DeskIconLinux.png" ]
then
rm -f ./resource/iNodeClient.png
cp -f ./custom/DeskIconLinux.png ./resource/iNodeClient.png
else
rm -f ./resource/iNodeClient.png
cp -f ./iNodeClient.png ./resource/iNodeClient.png
fi

if [ "$OS_ROCKY" != "" ]
then
pango-querymodules > '/etc/pango/pango.modules'
/etc/init.d/iNodeAuthService start
fi

if [ "$OS_ROCKY" = "" ]
then
service iNodeAuthService start
fi

cp -r /etc/iNodeTemp/clientfiles/ ./
rm -rf /etc/iNodeTemp
./iNodeClient.sh
