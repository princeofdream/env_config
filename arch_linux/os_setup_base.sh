#!/bin/bash -
#===============================================================================
#
#          FILE: os_setup_base.sh
#
#         USAGE: ./os_setup_base.sh
#
#   DESCRIPTION: Local OS setup base
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 07/15/2019 07:46:03 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error

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

	ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
	loge "tzselect"
	tzselect

	echo "LANG=en_US.UTF-8" > /etc/default/locale

	locale-gen

}	# ----------  end of function setup_locale  ----------

setup_network_base ()
{
	loge "Connect wifi/pppoe by using below commands:"
	loge "wifi-menu"
	loge "pppoe-setup"
	loge "systemctl start adsl"
}

setup_local_hw_time ()
{
	loge "hwclock --systohc --utc"
	hwclock --systohc --utc
}

setup_grub ()
{
	loge "Enter Setup grub to EFI..."
	pacman -S dosfstools grub efibootmgr

	mkinitcpio -p linux

	grub-install --target=$TARGET --efi-directory=/boot/EFI/ --recheck
	grub-mkconfig -o /boot/grub/grub.cfg
}

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




