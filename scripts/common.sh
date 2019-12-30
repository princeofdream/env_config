#!/bin/bash -
#===============================================================================
#
#          FILE: common.sh
#
#         USAGE: ./common.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 02/24/2018 04:07:45 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                              # treat unset variables as an error

cmd_readlink ()
{
   target_file=$1

   cd `dirname $target_file`
   target_file=`basename $target_file`

   # iterate down a (possible) chain of symlinks
   while [ -l "$target_file" ]
   do
       target_file=`readlink $target_file`
       cd `dirname $target_file`
       target_file=`basename $target_file`
   done

   # compute the canonicalized name by finding the physical path
   # for the directory we're in and appending the target file.
   phys_dir=`pwd -p`
   result=$phys_dir/$target_file
   echo $result
}  # ----------  end of function cmd_readlink  ----------

cmd_readlink="readlink -f"
$cmd_readlink $0 >/dev/null 2> /dev/null
if [[ $? != 0 ]]; then
   cmd_readlink="cmd_readlink"
fi

cmd_getopt=getopt
${cmd_getopt} > /dev/null 2> /dev/null
if [[ $? != 0 ]]; then
   cmd_getopt="busybox getopt"
fi

script_basename=$(basename $0)
script_path=$(dirname $($cmd_readlink "$0"))
if [[ $top_dir == "" ]]; then
	top_dir=${script_path}../
fi

if [[ ${vim_plug_manager_path}"x" == "x" ]]; then
	vim_plug_manager_path=$top_dir/common
fi

## TODO
## detect current system type
system_name=`uname -a`
system_type="linux"

if [[ $system_name == "msys"* ]]; then
	system_type="msys"
elif [[ $system_name == "mingw"* ]]; then
	system_type="mingw"
elif [[ $system_name == *"microsoft"*"linux"* ]]; then
	system_type="ms-linux"
elif [[ $system_name == *"darwin"* ]]; then
	system_type="mac"
fi

## TODO
## settup debug log
debug=0
log_count=0
log_color="true"

logd ()
{
	if [[ $debug == 0 ]]; then
		return 0
	fi

	current_time=`date +%h:%m:%s`

	if [[ "$log_color" == "true" ]]; then
		echo -e "[0;31;1m[ ${current_time} ] [dbg]\t[0m[0;34;1m$@ [0m"
	else
		echo -e "[ ${current_time} ] [dbg]\t$@ "
	fi

	if [[ $script_log_name"x" != "x" ]]; then
		if [[ $log_count == 0 ]]; then
			echo -e "[ ${current_time} ] [dbg]\t$@ " > $script_log_name
		else
			echo -e "[ ${current_time} ] [dbg]\t$@ " >> $script_log_name
		fi
	fi
	log_count=$((log_count+1))
	return 0
}	# ----------  end of function logd  ----------

log ()
{
	current_time=`date +%h:%m:%s`

	if [[ "$log_color" == "true" ]]; then
		echo -e "[0;31;1m[ ${current_time} ] [log]\t[0m[0;32;1m$@ [0m"
	else
		echo -e "[ ${current_time} ] [log]\t$@ "
	fi

	if [[ $script_log_name"x" != "x" ]]; then
		if [[ $log_count == 0 ]]; then
			echo -e "[ ${current_time} ] [log]\t$@ " > $script_log_name
		else
			echo -e "[ ${current_time} ] [log]\t$@ " >> $script_log_name
		fi
	fi
	log_count=$((log_count+1))
	return 0
}	# ----------  end of function logd  ----------

loge ()
{
	current_time=`date +%h:%m:%s`

	if [[ "$log_color" == "true" ]]; then
		echo -e "[0;31;1m[ ${current_time} ] [err]\t[0m[0;33;1m$@ [0m"
	else
		echo -e "[ ${current_time} ] [err]\t$@ "
	fi

	if [[ $script_log_name"x" != "x" ]]; then
		if [[ $log_count == 0 ]]; then
			echo -e "[ ${current_time} ] [err]\t$@ " > $script_log_name
		else
			echo -e "[ ${current_time} ] [err]\t$@ " >> $script_log_name
		fi
	fi
	log_count=$((log_count+1))
	return 0
}	# ----------  end of function loge  ----------

## TODO
## start project config
# log_path=$log_path/${script_basename%.*}/
# script_log_name=""
# script_log_name="$log_path/log_"$(script_basename)".log"

debug=0
## end of project config

usage_common() {
cat <<USAGE

Usage:
    bash $0 [OPTIONS]

Description:
    Check Network status and set network tools to get info

OPTIONS:
    -d, --debug
        Enable debugging
    -h, --help
        Display this help message
    -l, --log
        Log file to store build logs (Default: $log_path)
    -f, --log_file
        Log file to specified path
    -c, --no_color
        Do not display color

example. $0 -d -i -t
USAGE
}

# setup getopt.
# long_opts_common="debug,log,log_file:,help,no_color"
# getopt_cmd_common=$(${cmd_getopt} -o dhlf:c --long "$long_opts_common" \
#             -n $(basename $0) -- "$@") || \
#             { echo -e "\nerror: getopt failed. extra args\n"; usage_common; exit 1;}

get_options_common ()
{
	eval set -- "$getopt_cmd_common"

	while true; do
		case "$1" in
			-d|--debug) debug=1;;
			-l|--log) script_log_name="$log_path/log_${script_basename}.log";;
			-f|--log_file) script_log_name="$2/log_${script_basename}.log"; log_path=$2 shift;;
			-c|--no_color) log_color="false";;
			-h|--help) usage_common; exit 0;;
			--) shift; break;;
		esac
		shift
	done
}	# ----------  end of function get_options  ----------


