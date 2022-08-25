#!/bin/bash -
#===============================================================================
#
#          FILE: bashrc-login.sh
#
#         USAGE: ./bashrc-login.sh
#
#   DESCRIPTION: TODO
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: lijin (JamesL), lijin@consys.com.cn
#  ORGANIZATION: Consys
#       CREATED: 2022年08月24日 12时35分21秒
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error

config_debug=1
config_log_count=0
config_log_color="true"
config_log_dir="${script_path}"
config_log_name="log_"${script_path##*/}".log"
config_log_path=""


config_with_exit=false

# config_lsb_release=$(lsb_release -i 2>/dev/null |awk -f ':' '{print $2}'| sed -e 's/^[ \t]*//g')
# config_lsb_release=${config_lsb_release,,}
config_lsb_release=$(cat /etc/os-release | grep -i "^NAME" 2>/dev/null |awk -F '=' '{print $2}'| tr '[A-Z]' '[a-z]' |xargs echo)
config_lsb_release=${config_lsb_release%% *}

config_var_path_list="
$HOME/.config
$HOME/.cache"


######### End Setup basic script env ############

log_common ()
{
	local var_log_common_type="$1"
	local var_log_common_current_time="$(date +%H:%M:%S)"
	local var_log_common_fg_color=31
	local var_log_common_bg_color=32
	local var_log_common_label="log"

	case ${var_log_common_type} in
		debug | dbg )
			var_log_common_fg_color=31;
			var_log_common_bg_color=34;
			var_log_common_label="dbg";
			if [[ $config_debug == 0 ]]; then
				return 0;
			fi
			shift;
			;;
		normal | nor | log )
			var_log_common_fg_color=31;
			var_log_common_bg_color=32;
			var_log_common_label="log";
			shift;
			;;
		warning | wrn )
			var_log_common_fg_color=31;
			var_log_common_bg_color=33;
			var_log_common_label="wrn";
			shift;
			;;
		error | err )
			var_log_common_fg_color=31;
			var_log_common_bg_color=31;
			var_log_common_label="err";
			shift;
			;;
	esac

	if [[ "$config_log_color" == "true" ]]; then
		echo -e "[0;${var_log_common_fg_color};1m[ ${var_log_common_current_time} ] [${var_log_common_label}]\t[0m[0;${var_log_common_bg_color};1m$* [0m"
	else
		echo -e "[ ${var_log_common_current_time} ] [${var_log_common_label}]\t$* "
	fi

	if [[ $config_log_path"x" != "x" ]]; then
		if [[ $config_log_count == 0 ]]; then
			echo -e "[ ${var_log_common_current_time} ] [${var_log_common_label}]\t$* " > $config_log_path
		else
			echo -e "[ ${var_log_common_current_time} ] [${var_log_common_label}]\t$* " >> $config_log_path
		fi
	fi
	config_log_count=$((config_log_count+1))
	return 0
}	# ----------  end of function logd  ----------

logd ()
{
	log_common "dbg" "$@"
}	# ----------  end of function loge  ----------

log ()
{
	log_common "log" "$@"
}	# ----------  end of function loge  ----------

logw ()
{
	log_common "wrn" "$@"
}	# ----------  end of function loge  ----------

loge ()
{
	log_common "err" "$@"
}	# ----------  end of function loge  ----------

fatal_error ()
{
	local var_val=$1

	shift
	# logd "$*"
	loge "$*"

	if [[ "${var_val}" == "" ]]; then
		var_val=127
	fi

	if [[ "${config_with_exit}" == "true" ]]; then
		exit ${var_val}
	else
		return ${var_val}
	fi
}	# ----------  end of function fatal_func  ----------


rename_to_current_time ()
{
	local var_ret
	local var_item_path="$1"

	if [[ $# -lt 1 ]]; then
		fatal_error 100 "param incorrect" || return 100
	fi

	mv "${var_item_path}" \
		${var_item_path}.$(date +%Y%m%d_%H%M%S).bak

	return $var_ret
}	# ----------  end of function rename_to_current_time  ----------

detect_item ()
{
	local var_ret
	local var_exist=0
	local var_dir=0
	local var_file=0
	local var_link=0
	local var_path=$1

	if [[ "$var_path" == "" ]]; then
		return 104
	fi

	logd "======= detecting [${var_path}] ========="

	if [[ -e "${var_path}" ]]; then
		logd "exist [yes]"
		var_exist=100
	else
		logd "exist [no]"
		var_exist=0
	fi

	if [[ -h "${var_path}" ]]; then
		logd "link  [yes]"
		var_link=4
	else
		logd "link  [no]"
		var_link=0
	fi

	if [[ -d "${var_path}" ]]; then
		logd "dir   [yes]"
		var_dir=1
	else
		logd "dir   [no]"
		var_dir=0
	fi

	if [[ -f "${var_path}" ]]; then
		logd "file  [yes]"
		var_file=2
	else
		logd "file  [no]"
		var_file=0
	fi

	var_ret=$((${var_exist} + ${var_link} +${var_dir} + ${var_file}))

	return $var_ret
}	# ----------  end of function detect_item  ----------


update_item_path ()
{
	local var_ret
	local var_item_path
	local var_item_dir
	local var_item_name
	local var_item_os
	local var_item_curr
	local var_item_stat

	local var_item_mode

	local var_item_exist=0


	var_item_path=$1
	var_item_mode=$2
	# var_item_path=$HOME/.config

	if [[ "${var_item_path}" == "" ]]; then
		fatal_error 100 "param error" || return 100
	fi

	var_item_name=${var_item_path##*/}
	var_item_dir=${var_item_path%/*}

	var_item_os=${var_item_name}_${config_lsb_release}
	var_item_curr=$(readlink ${var_item_path})

	## NOTE
	## 100 -- exist
	##   1 -- dir
	##   2 -- file
	##   4 -- link

	cd ${var_item_dir}
	var_ret=$?
	if [[ $var_ret -ne 0 ]]; then
		fatal_error 100 || return 100
	fi

## 1. first detect item_os
##    if not exist, create dir/file (var_item_mode)
	detect_item "${var_item_dir}/${var_item_os}"
	var_item_stat=$?
	if [[ ${var_item_stat} -ge 100 ]]; then
		var_item_exist=1
		var_item_stat=$((${var_item_stat}%100))
	else
		var_item_exist=0
	fi

	## NOTE
	## file not exist and this is not a link
	if [[ ${var_item_stat} -lt 4  &&
		${var_item_exist} -eq 0 ]]; then
		logd "[${var_item_os}] not exist and not link"
		if [[ "${var_item_mode}" == "1" ]]; then
			mkdir -p  ${var_item_dir}/
			touch ${var_item_dir}/${var_item_os}
		else
			mkdir -p ${var_item_dir}/${var_item_os}
		fi
	fi

## 2. second detect item
##
	detect_item "${var_item_dir}/${var_item_name}"
	var_item_stat=$?
	if [[ ${var_item_stat} -ge 100 ]]; then
		var_item_exist=1
		var_item_stat=$((${var_item_stat}%100))
	else
		var_item_exist=0
	fi

	## NOTE
	## link --> no --> exist --> no   [really not exist] ==> create it
	## link --> no --> exist --> yes  [file/dir]         ==> rename it, create again
	## link --> yes --> exist --> no  [dist not good]    ==> rename it, create again
	## link --> yes --> exist --> yes                    ==> check link distination
	##                                      link correct ==> do nothing
	##                                    link incorrect ==> rename link create new link
	if [[ ${var_item_stat} -lt 4 ]]; then
		## not a link
		if [[ ${var_item_exist} -eq 0 ]]; then
			## not exit, real not exist
			if [[ "${var_item_mode}" == "1" ]]; then
				mkdir -p ${var_item_dir}/
				touch ${var_item_dir}/${var_item_name}
			else
				ln -s ${var_item_os} ${var_item_name}
			fi
		else
			# if [[ ${var_item_stat} -eq 0 ]]; then
				rename_to_current_time ${var_item_dir}/${var_item_name}
				logd "${LINENO} rename_to_current_time ${var_item_dir}/${var_item_name}"
				var_ret=$?
				if [[ $var_ret -ne 0 ]]; then
					return $var_ret
				fi
			# fi
			cd ${var_item_dir} && \
			ln -s ${var_item_os} ${var_item_name}
		fi
	elif [[ ${var_item_stat} -ge 4 ]]; then
		if [[ ${var_item_exist} -eq 0 ]]; then
			logd "${LINENO} rename_to_current_time ${var_item_dir}/${var_item_name}"
			rename_to_current_time ${var_item_dir}/${var_item_name}
			var_ret=$?
			if [[ $var_ret -ne 0 ]]; then
				return $var_ret
			fi
			cd ${var_item_dir} && \
			ln -s ${var_item_os} ${var_item_name}
		else
			local var_item_link_dist

			var_item_link_dist=$(ls -l --time-style="+%Y" ${var_item_dir}/${var_item_name} |awk -F"->" '{print $2}')
			var_item_link_dist=$(echo ${var_item_link_dist})
			var_item_link_dist=${var_item_link_dist##*/}

			if [[ "${var_item_link_dist}" = "${var_item_os}" ]]; then
				logd "do nothing"
				return 0
			fi

			# logd "${LINENO} rename $(ls -l --time-style="+%Y" ${var_item_dir}/${var_item_name})"
			# rename_to_current_time ${var_item_dir}/${var_item_name}
			# echo "$(date +%Y-%m-%d_%H:%M:%S) -- $(ls -l --time-style=+%Y ${var_item_dir}/${var_item_name})" >> ${var_item_dir}/.link.log
			rm ${var_item_dir}/${var_item_name}
			var_ret=$?
			if [[ $var_ret -ne 0 ]]; then
				return $var_ret
			fi
			cd ${var_item_dir} && \
			ln -s ${var_item_os} ${var_item_name}
		fi
		## link, check destination
	fi

	return $var_ret
}	# ----------  end of function update_item_path  ----------



update_list ()
{
	local var_ret=0

	for var_item in ${config_var_path_list};
	do
		update_item_path ${var_item}
		var_ret=$?
		if [[ $var_ret -ne 0 ]]; then
			return $var_ret
		fi
	done

	return $var_ret
}	# ----------  end of function update_list  ----------

main ()
{
	local var_ret

	logd "start main..."
	if [[ "${config_lsb_release}" == "" ]]; then
		fatal_error 100 "error to get os-release" || return 100
	fi

	update_list
	if [[ -e ${HOME}/envx ]]; then
		update_item_path ${HOME}/envx/env_rootfs
		var_ret=$?
		if [[ $var_ret -ne 0 ]]; then
			return $var_ret
		fi
	fi

	return $var_ret
}	# ----------  end of function main  ----------


# log "current os: ${config_lsb_release}" >> $HOME/current_os
main $*
logd "end main..."
if [[ "${config_with_exit}" == "true" ]]; then
	exit $?
fi



