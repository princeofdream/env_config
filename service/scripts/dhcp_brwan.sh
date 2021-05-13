#!/bin/bash -
#===============================================================================
#
#          FILE: dhcp_brwan.sh
#
#         USAGE: ./dhcp_brwan.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2021年05月13日 14时23分13秒
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error

######### Start Setup env to get script path ############
readlink_func ()
{
   target_file=$1

   cd "$(dirname "${target_file}")" || return 127
   target_file=$(basename $target_file)

   # iterate down a (possible) chain of symlinks
   while [ -f "${target_file}" ];
   do
	   target_file=$(readlink ${target_file})
	   cd "$(dirname "${target_file}")" || return 127
	   target_file=$(basename ${target_file})
	   if [[ ! -L ${target_file} ]]; then
		   break
	   fi
   done

   # compute the canonicalized name by finding the physical path
   # for the directory we're in and appending the target file.
   phys_dir=$(pwd -P)
   result=$phys_dir/$target_file
   echo $result
}  # ----------  end of function readlink_func  ----------

cmd_readlink="readlink -f"
if ! $cmd_readlink $0 >/dev/null 2> /dev/null
then
   cmd_readlink="readlink_func"
fi
######### end setup env to get script path ############

script_path=$(dirname "$($cmd_readlink "$0")")
top_path=${script_path}
# source ${top_path}/common/common.sh
######### start setup basic script env ############
debug=0
log_count=0
log_color="true"
log_path="${script_path}"
log_name="log_"$(basename $0)".log"
script_log_path=""
######### End Setup basic script env ############

logd ()
{
	if [[ $debug == 0 ]]; then
		return 0
	fi

	local current_time="$(date +%H:%M:%S)"

	if [[ "$log_color" == "true" ]]; then
		echo -e "[0;31;1m[ ${current_time} ] [dbg]\t[0m[0;34;1m$* [0m"
	else
		echo -e "[ ${current_time} ] [dbg]\t$* "
	fi

	if [[ $script_log_path"x" != "x" ]]; then
		if [[ $log_count == 0 ]]; then
			echo -e "[ ${current_time} ] [dbg]\t$* " > $script_log_path
		else
			echo -e "[ ${current_time} ] [dbg]\t$* " >> $script_log_path
		fi
	fi
	log_count=$((log_count+1))
	return 0
}	# ----------  end of function logd  ----------

log ()
{
	local current_time="$(date +%H:%M:%S)"

	if [[ "$log_color" == "true" ]]; then
		echo -e "[0;31;1m[ ${current_time} ] [log]\t[0m[0;32;1m$* [0m"
	else
		echo -e "[ ${current_time} ] [log]\t$* "
	fi

	if [[ $script_log_path"x" != "x" ]]; then
		if [[ $log_count == 0 ]]; then
			echo -e "[ ${current_time} ] [log]\t$* " > $script_log_path
		else
			echo -e "[ ${current_time} ] [log]\t$* " >> $script_log_path
		fi
	fi
	log_count=$((log_count+1))
	return 0
}	# ----------  end of function logd  ----------

logw ()
{
	local current_time="$(date +%H:%M:%S)"

	if [[ "$log_color" == "true" ]]; then
		echo -e "[0;31;1m[ ${current_time} ] [wrn]\t[0m[0;33;1m$* [0m"
	else
		echo -e "[ ${current_time} ] [wrn]\t$* "
	fi

	if [[ $script_log_path"x" != "x" ]]; then
		if [[ $log_count == 0 ]]; then
			echo -e "[ ${current_time} ] [wrn]\t$* " > $script_log_path
		else
			echo -e "[ ${current_time} ] [wrn]\t$* " >> $script_log_path
		fi
	fi
	log_count=$((log_count+1))
	return 0
}	# ----------  end of function loge  ----------

loge ()
{
	local current_time="$(date +%H:%M:%S)"

	if [[ "$log_color" == "true" ]]; then
		echo -e "[0;31;1m[ ${current_time} ] [err]\t[0m[0;33;1m$* [0m"
	else
		echo -e "[ ${current_time} ] [err]\t$* "
	fi

	if [[ $script_log_path"x" != "x" ]]; then
		if [[ $log_count == 0 ]]; then
			echo -e "[ ${current_time} ] [err]\t$* " > $script_log_path
		else
			echo -e "[ ${current_time} ] [err]\t$* " >> $script_log_path
		fi
	fi
	log_count=$((log_count+1))
	return 0
}	# ----------  end of function loge  ----------

force_root_permission ()
{
	local uid=$(id -u)
	if [[ ${uid} != 0 ]]; then
		loge "Check permission fail! Please use root to exec this script"
		exit;
	fi
	return 0;
}	# ----------  end of function force_root_permission  ----------

######### Start Setup custom script env ############
build_version=""
build_platform=""
build_cpu=""
build_edition="server"
build_mode=""
build_platform="s920_arm"
build_fake_rootfs_path="/mnt/rootfs"
build_src_fs_img=""
build_overlay_rootfs=""
build_src_iso_files_path=""
build_src_rootfs_path=""
build_default_desktop="desktop_sp4_ft2k"
build_default_server="server_sp2_ft2kplus"
build_project="${build_default_server}"
build_work_path=""
build_date=""
cmd_7z=7z
######### End Setup custom script env ############

usage() {
cat <<USAGE

Usage:
    bash $0 [OPTIONS]

Description:
    Sample script

OPTIONS:
    -d, --debug
        Enable debugging - captures all commands while doing the build
    -h, --help
        Display this help message
    -l, --log
        Log file to store build logs (Default: $log_path)
    -f, --log_file
        Log file to specified path
    -c, --no_color
        Log file to specified path
    -s, --src
        Source install file system
    -o, --overlay
        Overlay rootfs path
    -p, --edition
        Build project [ *s920_arm ]
    -e, --edition
        Build image edition [ *server | desktop ]
    -m, --mode
        Build mode [ *src | repack | fs | gen_igr | del_igr | empty_dir ]

        src       : 从项目源包打包成ISO
        repack    : 解压ISO，合并overlay目录后重新打包成为新的ISO
        fs        : 打包rootfs到filesystem.squashfs
        gen_igr   : 为空文件生成 .gitignore 文件（依赖 empty_dir.lst)
        del_igr   : 为空文件生成 .gitignore 文件（依赖 empty_dir.lst)
        empty_dir : 生成空文件夹列表 empty_dir.lst

Usage:
    $0 -m src -e server [ -p server_sp4_ft2kplus ]
    $0 -m repack -s /path/to/Kylin-server-sp4.iso -o overlay_rootfs -e server
    $0 -m fs -e server [ -p server_sp4_ft2kplus ]

    $0 -m gen_igr -e server
    $0 -m del_igr -e server
    $0 -m empty_dir -e server
    $0 -m gen_files_list -e server -s /path/to/org.iso
USAGE
}

######### Start Setup script arguments ############
long_opts="debug,log,log_file:,no_color,help:"
long_opts+=",mode:,version:"
getopt_cmd=$(getopt -o dlf:chs:p:e:o:m:v: --long "$long_opts" \
			-n $(basename $0) -- "$@") || \
			{ loge "\nERROR: Getopt failed. Extra args\n"; usage; exit 1;}

eval set -- "$getopt_cmd"
while true; do
	case "$1" in
		-d|--debug) debug=1;;
		-l|--log) script_log_path=${log_path}/${log_name};;
		-f|--log_file) log_path=$2;
			if [[ -d ${log_path} ]]; then
				script_log_path=${log_path}/${log_name};
			else
				script_log_path=${2}
			fi; shift;;
		-c|--no_color) log_color="";;
		-h|--help) usage;;
		-s|--src) build_src_fs_img=$2;shift;;
		-m|--mode) build_mode=$2;shift;;
		-v|--version) build_version=$2;shift;;
		--) shift; break;;
	esac
	shift
done
######### End Setup script arguments ############


setup_bridge ()
{
	bridge_name="$1"
	bridge_ipaddr="$2"
	bridge_iface="$3"

	log "brctl addbr ${bridge_name}"
	brctl addbr ${bridge_name}
	log "ifconfig ${bridge_name} ${bridge_ipaddr}"
	ifconfig ${bridge_name} ${bridge_ipaddr}

	if [[ ${bridge_iface}"" != "" ]]; then
		log "brctl addif ${bridge_name} ${bridge_iface}"
		brctl addif ${bridge_name} ${bridge_iface}
		log "ifconfig ${bridge_iface} 0.0.0.0"
		ifconfig ${bridge_iface} 0.0.0.0
	fi

	return 0;
}	# ----------  end of function setup_bridge  ----------

main_func ()
{
	force_root_permission

	setup_bridge "br-wan" "192.168.7.1" "enp3s0f3u2u3"
	return 0;
}	# ----------  end of function main_func  ----------


main_func "$*"
ret=$?
exit ${ret}


