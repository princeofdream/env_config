#!/bin/bash
#
# Copyright (c) 2012, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

set -o errexit
set -o pipefail

SCRIPT_PATH=$(dirname $(readlink -f "$0"))
TOP_DIR=${SCRIPT_PATH}

# Set defaults
TARGET=e28
VARIANT="eng"
JOBS=12
CCACHE="true"
BUILD_TYPE="msm8996"
# GET_BY_DATE=`date +%Y%m%d`
GET_BY_DATE=""

ROM_BUILD_TIME="$(date +%Y%m%d%H%M)"

CREATE_NEW_PARTITION=y
FORMAT_PARTITION=y

MOUNT_POINT_ROOT=/mnt
## rootfs will be ext4
## bootfs will be ext4
## efifs will be fat32
ROOTFS_PAR="/dev/sda3"
BOOTFS_PAR="/dev/sda2"
EFIFS_PAR="/dev/sda1"
HOMEFS_PAR=""

OS_INSTALL="false"
OS_SETUP="false"

DEBUG=0
logd ()
{
	if [[ $DEBUG == 0 ]]; then
		return 0
	fi
	CURRENT_TIME=`date +%H:%M:%S`
	echo -e "[0;31;1m[ ${CURRENT_TIME} ]\t[0m[0;32;1m$@ [0m"
	return 0
}	# ----------  end of function logd  ----------

loge ()
{
	CURRENT_TIME=`date +%H:%M:%S`
	echo -e "[0;31;1m[ ${CURRENT_TIME} ]\t[0m[0;32;1m$@ [0m"
	return 0
}	# ----------  end of function logd  ----------

usage() {
cat <<USAGE

Usage:
    bash $0 <TARGET_PRODUCT> [OPTIONS]

Description:
    Builds Android tree for given TARGET_PRODUCT

OPTIONS:
    -d, --debug
        Enable debugging - captures all commands while doing the build
    -h, --help
        Display this help message
    -i, --image
        Specify image to be build/re-build (android/boot/bootimg/sysimg/usrimg/lk/vendor/vbmeta)
    -j, --jobs
        Specifies the number of jobs to run simultaneously (Default: 8)
    -l, --log_file
        Log file to store build logs (Default: <TARGET_PRODUCT>.log)
    -s, --setup
        Set CCACHE for faster incremental builds (true/false - Default: true)

USAGE
}

enable_system_service ()
{
	ret=0
	systemctl enable $@
	ret=$?
	if [[ ! $ret -eq 0 ]]; then
		loge "Enable Service $@ Failed!"
		return $ret
	fi
	systemctl start $@
	ret=$?
	if [[ ! $ret -eq 0 ]]; then
		loge "Start Service $@ Failed!"
		return $ret
	fi
}	# ----------  end of function enable_system_service  ----------


create_new_partition ()
{
	if [[ ! $CREATE_NEW_PARTITION == "y" ]]; then
		logd "Do not create new partition!"
		return 0;
	fi

	loge "---------------- WARNING -----------------"
	read -p "Make sure to create and format disks: (y/n)" ANSWER
	loge "------------------------------------------"
	loge "select: $ANSWER"

	if [[ $ANSWER == "y" ]]; then
		loge "Start to crerate new partitions...."
		sleep 3
	else
		loge "Selection incorrect, will not create new partition!"
	fi

	return $ret
}	# ----------  end of function create_new_partition  ----------


format_partition ()
{
	if [[ ! $FORMAT_PARTITION == "y" ]]; then
		logd "Do not format partition!"
		return 0;
	fi

	ANSWER_DOUBLE_CHECK="n"

	loge "---------------- WARNING -----------------"
	read -p "Make sure to format disks: (y/n)" ANSWER
	loge "------------------------------------------"
	loge "select: $ANSWER"

	if [[ $ANSWER == "y" ]]; then
		loge "$ROOTFS_PAR & $BOOTFS_PAR & $EFIFS_PAR is going to format"
		read -p "Make sure to create and format disks: (y/n)" ANSWER_DOUBLE_CHECK

		if [[ ! $ANSWER_DOUBLE_CHECK == "y" ]]; then
			loge "Selection <$ANSWER_DOUBLE_CHECK> incorrect, will not create new partition!"
		fi
	else
		loge "Selection <$ANSWER> incorrect, will not create new partition!"
	fi

	if [[ ! $ANSWER_DOUBLE_CHECK == "y" ]]; then
		return 128;
	fi

	loge "mkfs.fat -F32 $EFIFS_PAR"
	loge "mkfs.ext4 $BOOTFS_PAR"
	loge "mkfs.ext4 $ROOTFS_PAR"

	# mkfs.fat -F32 $EFIFS_PAR
	# mkfs.ext4 $BOOTFS_PAR
	# mkfs.ext4 $ROOTFS_PAR

	return $ret
}	# ----------  end of function format_partition  ----------

mount_partitions ()
{
	ret=0
	loge "
	mount devices:
	mount $ROOTFS_PAR $MOUNT_POINT_ROOT
	mkdir -p $MOUNT_POINT_ROOT/boot
	mount $BOOTFS_PAR $MOUNT_POINT_ROOT/boot
	mkdir -p $MOUNT_POINT_ROOT/boot/EFI
	mount $EFIFS_PAR $MOUNT_POINT_ROOT/boot/EFI
	"

	loge "Mount rootfs ..."
	mount $ROOTFS_PAR $MOUNT_POINT_ROOT
	ret=$?
	if [[ ! $ret -eq 0 ]]; then
		loge "mount $ROOTFS_PAR to $MOUNT_POINT_ROOT Failed!"
		return $ret
	fi

	loge "Mount bootfs ..."
	mkdir -p $MOUNT_POINT_ROOT/boot
	mount $BOOTFS_PAR $MOUNT_POINT_ROOT/boot
	ret=$?
	if [[ ! $ret -eq 0 ]]; then
		loge "mount $BOOTFS_PAR to $MOUNT_POINT_ROOT/boot Failed!"
		return $ret
	fi

	loge "Mount efifs ..."
	mkdir -p $MOUNT_POINT_ROOT/boot/EFI
	mount $EFIFS_PAR $MOUNT_POINT_ROOT/boot/EFI
	ret=$?
	if [[ ! $ret -eq 0 ]]; then
		loge "mount $EFIFS_PAR to $MOUNT_POINT_ROOT/boot/EFI Failed!"
		return $ret
	fi

	if [[ ! $HOMEFS_PAR == "" ]]; then
		loge "Mount homefs ..."
		mkdir -p $MOUNT_POINT_ROOT/home
		mount $HOMEFS_PAR $MOUNT_POINT_ROOT/home
		ret=$?
		if [[ ! $ret -eq 0 ]]; then
			loge "mount $EFIFS_PAR to $MOUNT_POINT_ROOT/boot/EFI Failed!"
			return $ret
		fi
	fi

	return $?
}

install_arch_linux ()
{
	loge "Start install Arch Linux"
	pacstrap -i $MOUNT_POINT_ROOT base base-devel
}

setup_mount_tables_fstab ()
{
	loge "genfstab -U $MOUNT_POINT_ROOT >> $MOUNT_POINT_ROOT/etc/fstab"

	genfstab -U $MOUNT_POINT_ROOT >> $MOUNT_POINT_ROOT/etc/fstab
	cat $MOUNT_POINT_ROOT/etc/fstab
}

setup_network_service ()
{
	pacman -S networkmanager
	enable_system_service NetworkManager.service

	return $ret
}	# ----------  end of function setup_network_service  ----------

setup_network_tools ()
{
	pacman -S net-tools dnsutils inetutils iproute2

	return $ret
}	# ----------  end of function setup_network_tools  ----------

setup_locale ()
{
	LOCALE_FILE="/etc/locale.gen"

	sed -i "s/#zh_CN.UTF-8\ UTF-8/zh_CN.UTF-8 UTF-8/g" ${LOCALE_FILE}
	sed -i "s/#en_US.UTF-8\ UTF-8/en_US.UTF-8 UTF-8/g" ${LOCALE_FILE}

	locale-gen

	ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
	loge "tzselect"
	tzselect

}	# ----------  end of function setup_locale  ----------

setup_network_base ()
{
	loge "Connect wifi/pppoe by using below commands:"
	loge "wifi-menu"
	loge "pppoe-setup"
	loge "systemctl start adsl"
}

sync_time_with_ntp ()
{
	loge "Enter sync_time_with_ntp"
	loge "timedatectl set-ntp true"
	timedatectl set-ntp true
}

setup_local_hw_time ()
{
	loge "hwclock --systohc --utc"
	hwclock --systohc --utc
}

setup_pacman_mirror ()
{
	loge "Enter setup_pacman_mirror"
	PACMAN_MIRROR_LIST_FILE="/etc/pacman.d/mirrorlist"
	CN_MIRROR_SITE=`cat ${PACMAN_MIRROR_LIST_FILE} |grep tsinghua|head -n 1`
	loge "get mirror site: ${CN_MIRROR_SITE}"
	sed -i "1i\\${CN_MIRROR_SITE}" ${PACMAN_MIRROR_LIST_FILE}
}

setup_grub ()
{
	loge "Enter Setup grub to EFI..."
	pacman -S dosfstools grub efibootmgr

	mkinitcpio -p linux

	grub-install --target=x86_64-efi --efi-directory=/boot/EFI/ --recheck
	grub-mkconfig -o /boot/grub/grub.cfg
}

setup_install_system ()
{
	ret=0

	loge "Start install system..."

	setup_pacman_mirror $@
	sync_time_with_ntp $@

	# create_new_partition $@
	# format_partition $@
	mount_partitions $@
	install_arch_linux $@

	setup_mount_tables_fstab $@

	loge ""
	loge "Change root to local system"
	loge "arch-chroot $MOUNT_POINT_ROOT"

	return $ret
}	# ----------  end of function setup_install_system  ----------

setup_local_system ()
{
	ret=0
	loge "Start setup local system..."

	setup_locale

	setup_network_tools
	setup_network_service

	setup_local_hw_time

	setup_grub

	ret=$?

	return $ret
}


main_func ()
{
	ret=0

	loge "install: $OS_INSTALL; setup: $OS_SETUP"
	if [[ $OS_INSTALL == "true" ]]; then
		setup_install_system
	elif [[ $OS_SETUP == "true" ]]; then
		setup_local_system
	fi
	ret=$?

	return $ret
}	# ----------  end of function main_func  ----------


# if [ $# -eq 0 ]; then
#     echo -e "\nERROR: No arguments Found!\n"
#     usage
#     exit 1
# fi
# Setup getopt.
long_opts="debug,help,install,jobs:,log_file:,"
long_opts+="setup"
getopt_cmd=$(getopt -o cdhij:l:s --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "\nERROR: Getopt failed. Extra args\n"; usage; exit 1;}

eval set -- "$getopt_cmd"

loge "args: $@"
while true; do
    case "$1" in
        -d|--debug) DEBUG="true";;
        -h|--help) usage; exit 0;;
        -i|--install) OS_INSTALL="true";;
        -j|--jobs) JOBS="$2"; shift;;
        -l|--log_file) LOG_FILE="$2"; shift;;
        -s|--setup) OS_SETUP="true";;
        --) shift; break;;
    esac
	shift
done


BUILD_START_TIME=$(date +%Y/%m/%d-%H:%M:%S)
loge "Start Build: ${BUILD_START_TIME}"

main_func $@

BUILD_END_TIME=$(date +%Y/%m/%d-%H:%M:%S)
if [[ $? == 0 ]]; then
	loge "Build Success: ${BUILD_END_TIME}"
else
	loge "Build Fail: ${BUILD_END_TIME}"
fi

