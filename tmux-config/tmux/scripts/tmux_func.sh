#!/bin/bash -
#===============================================================================
#
#          FILE: tmux_scripts.sh
#
#         USAGE: ./tmux_scripts.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2020年08月31日 11时18分44秒
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error


_toggle_mouse() {
	old=$(tmux show -gv mouse)
	new=""

	if [ "$old" = "on" ]; then
	 new="off"
	else
	 new="on"
	fi

	tmux set -g mouse $new \;\
		display "mouse: $new"
	# echo "toggle mouse....old is ${old}"
}


main_func () {
	$@
}


main_func $@
exit $?





