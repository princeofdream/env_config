#!/bin/bash -
#===============================================================================
#
#          FILE: debug_utils.sh
#
#         USAGE: ./debug_utils.sh
#
#   DESCRIPTION: debug utils
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 07/15/2019 07:53:10 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error

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
}	# ----------  end of function loge  ----------

