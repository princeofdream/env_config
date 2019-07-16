#!/bin/bash -
#===============================================================================
#
#          FILE: arch_setup.sh
#
#         USAGE: ./arch_setup.sh
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

set -o errexit
set -o pipefail

SCRIPT_PATH=$(dirname $(readlink -f "$0"))
TOP_DIR=${SCRIPT_PATH}

# Set defaults
TARGET=x86_64-efi
JOBS=12
# GET_BY_DATE=`date +%Y%m%d`
GET_BY_DATE=""

OS_INSTALL="false"
OS_SETUP="false"
EXTRA_MODE=""

DEBUG=0

source $TOP_DIR/debug_utils.sh

source $TOP_DIR/os_install.sh
source $TOP_DIR/os_setup_base.sh

source $TOP_DIR/utils.sh

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
        Setup local OS
    -u, --utils
        Setup local utils

USAGE
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
	if [[ $EXTRA_MODE == "utils" ]]; then
		setup_base_utils $@
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
long_opts+="utils,setup"
getopt_cmd=$(getopt -o cdhij:l:us --long "$long_opts" \
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
        -u|--utils) EXTRA_MODE="utils";;
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

