#!/usr/bin/env bash
#===============================================================================
#
#          FILE: space.sh
#
#         USAGE: ./space.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 03/02/2019 01:53:53 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                              # Treat unset variables as an error

SRC_PARAM=""

get_message_length ()
{
	# echo "--->>>${SRC_PARAM}<<<---"
	echo "${#SRC_PARAM}"
}	# ----------  end of function get_message_length  ----------




main ()
{
	if [[ $PARAM == "get_message_length" ]]; then
		get_message_length
	fi
}	# ----------  end of function main  ----------



# Setup getopt.
long_opts="length:"
getopt_cmd=$(getopt -o l: --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "\nERROR: Getopt failed. Extra args\n"; usage; exit 1;}

eval set -- "$getopt_cmd"

# echo "args: $@"
while true; do
    case "$1" in
		-l|--length) PARAM="get_message_length"; SRC_PARAM="$@"; SRC_PARAM=${SRC_PARAM#* }; SRC_PARAM=${SRC_PARAM%--*}; shift;;
        --) shift; break;;
    esac
	shift
done



main $@



