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

mv -f iNodeClient_Linux.tar.gz /etc/iNodeTemp
./uninstall.sh

tar -xzvf /etc/iNodeTemp/iNodeClient_Linux.tar.gz -C $(dirname $INSTALL_DIR)
cd $INSTALL_DIR
if [ -r "./install_64.sh" ]
then
./install_64.sh
else
./install.sh
fi
cp -r /etc/iNodeTemp/clientfiles/ ./
rm -rf /etc/iNodeTemp
./iNodeClient.sh
