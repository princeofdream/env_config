#!/bin/bash -
#===============================================================================
#
#          FILE: os_install.sh
#
#         USAGE: ./os_install.sh
#
#   DESCRIPTION: OS install functions
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 07/15/2019 07:41:36 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error

MOUNT_POINT_ROOT=/mnt
## rootfs will be ext4
## bootfs will be ext4
## efifs will be fat32
ROOTFS_PAR="/dev/sda7"
BOOTFS_PAR=""
EFIFS_PAR="/dev/sda1"
HOMEFS_PAR="/dev/sda2"

ROOTFS_MOUNT_POINT=""
BOOTFS_MOUNT_POINT=boot
EFIFS_MOUNT_POINT=boot/EFI


CREATE_NEW_PARTITION=y
FORMAT_PARTITION=y


setup_pacman_mirror ()
{
	loge "Enter setup_pacman_mirror"
	PACMAN_MIRROR_LIST_FILE="/etc/pacman.d/mirrorlist"
	CN_MIRROR_SITE=`cat ${PACMAN_MIRROR_LIST_FILE} |grep tsinghua|head -n 1`
	loge "get mirror site: ${CN_MIRROR_SITE}"
	sed -i "1i\\${CN_MIRROR_SITE}" ${PACMAN_MIRROR_LIST_FILE}
}

sync_time_with_ntp ()
{
	loge "Enter sync_time_with_ntp"
	loge "timedatectl set-ntp true"
	timedatectl set-ntp true
}

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

	mount $ROOTFS_PAR $MOUNT_POINT_ROOT/$ROOTFS_MOUNT_POINT

	mkdir -p $MOUNT_POINT_ROOT/$BOOTFS_MOUNT_POINT
	mount $BOOTFS_PAR $MOUNT_POINT_ROOT/$BOOTFS_MOUNT_POINT

	mkdir -p $MOUNT_POINT_ROOT/$EFIFS_MOUNT_POINT
	mount $EFIFS_PAR $MOUNT_POINT_ROOT/$EFIFS_MOUNT_POINT
	"

	loge "Mount rootfs ..."
	mount $ROOTFS_PAR $MOUNT_POINT_ROOT
	ret=$?
	if [[ ! $ret -eq 0 ]]; then
		loge "mount $ROOTFS_PAR to $MOUNT_POINT_ROOT Failed!"
		return $ret
	fi

	if [[ ! $BOOTFS_PAR == "" ]]; then
		loge "Mount bootfs ..."
		mkdir -p $MOUNT_POINT_ROOT/boot
		mount $BOOTFS_PAR $MOUNT_POINT_ROOT/boot
		ret=$?
		if [[ ! $ret -eq 0 ]]; then
			loge "mount $BOOTFS_PAR to $MOUNT_POINT_ROOT/boot Failed!"
			return $ret
		fi
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

