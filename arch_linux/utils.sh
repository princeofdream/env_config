#!/bin/bash -
#===============================================================================
#
#          FILE: utils.sh
#
#         USAGE: ./utils.sh
#
#   DESCRIPTION: utils
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 07/15/2019 07:57:21 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error


setup_gui_desktop ()
{
	pacman -S gnome gdm gnome-extra gnome-tweak-tool gvfs-mtp plasma konsole kdeutils
}	# ----------  end of function setup_gui_desktop  ----------


setup_wayland ()
{
	pacman -S weston
}	# ----------  end of function setup_wayland  ----------


setup_common_utils ()
{
	pacman -S vim git iw wpa_supplicant dhcpcd dialog openssh alsa-utils libreoffice

	enable_system_service wpa_supplicant
	# enable_system_service dhcpcd
}	# ----------  end of function setup_common_utils  ----------


fix_ssh_transfer_err ()
{
	if [[ ! -f $HOME/.ssh/config ]]; then
		mkdir -p $HOME/.ssh
		echo "
host *
	IPQoS lowdelay throughput
" >> $HOME/.ssh/config
		return $?
	fi

#     SSH_STAT=`cat ~/.ssh/config|grep throughput`
#     loge "ssh stat: $SSH_STAT"
#     if [[ $SSH_STAT == "" ]]; then
#         echo "
# host *
#     IPQoS lowdelay throughput
# " >> $HOME/.ssh/config
#     fi

}	# ----------  end of function fix_ssh_transfer_err  ----------


setup_base_utils ()
{
	ret=0
	fix_ssh_transfer_err
	setup_common_utils
	setup_wayland
	setup_gui_desktop
	return $ret
}

