#!/bin/bash -
#===============================================================================
#
#          FILE: build.sh
#
#         USAGE: ./build.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2018年05月06日 16时52分42秒
#      REVISION:  ---
#===============================================================================

# set -o nounset                              # Treat unset variables as an error

## start general setup curent script env
## like script path, name etc.(source basic_env.sh may overwrite it)
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

#########################################
## TODO
## define new parameters here
#########################################
current_script_basename=$(basename $0)
current_script_path=$(dirname $($cmd_readlink "$0"))

#################################################################################
## TODO define project config
script_path=${current_script_path}
script_basename=${current_script_basename}
top_dir=${script_path}
#################################################################################

source ${current_script_path}/scripts/process_main.sh
#########################################
## TODO
## define overwrite parameters here
#########################################

## end of general setup curent script env

## TODO
## start project config
if [[ ${log_path}"x" == "x" ]]; then
	log_path=log_${script_basename%.*}/
else
	log_path=$log_path/log_${script_basename%.*}/
fi
script_log_name=""
# script_log_name="$log_path/log_"$(script_basename)".log"

debug=0
usage() {
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
    -e, --env
        Setup basic env (work dir: env_base)
    -v, --vim
        Setup basic vim env (work dir: vimfiles)
    -t, --tmux
        Setup basic tmux env (work dir: tmux-config)
    -p, --path
        Setup path for pre env (work dir: env_base)
    -b, --build
        Build env
    -x, --extra
		Custom setup env (fox ex. $0 -x env_base / $0 -x vim)
    -q, --quit
		Quit after setup done

example. $0 -e
USAGE
}

setup_env=""
setup_vim=""
setup_tmux=""
setup_path=""
setup_compress=""
setup_build=""
setup_extra=""
setup_quit="quit"

# setup getopt.
long_opts="debug,log,log_file:,help,no_color,env,vim,tmux,path:,build,extra:"
long_opts+=",quit"
getopt_cmd=$(${cmd_getopt} -o dhlf:cevtp:bx:q --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "\nerror: getopt failed. extra args\n"; usage; exit 1;}

# get_options ()
# {
	eval set -- "$getopt_cmd"

	while true; do
		case "$1" in
			-d|--debug) debug=1;;
			-h|--help) usage; exit 0;;
			-l|--log) script_log_name="$log_path/log_${script_basename}.log";;
			-f|--log_file) script_log_name="$2/log_${script_basename}.log"; log_path=$2 shift;;
			-c|--no_color) log_color="false";;
			-e|--env) setup_env="env_base";;
			-v|--vim) setup_vim="vim";;
			-t|--tmux) setup_tmux="tmux";;
			-p|--path) setup_path="$2"; shift;;
			-b|--build) setup_build="build"; shift;;
			-x|--extra) setup_build="$2"; shift;;
			-q|--quit) setup_quit="null"; shift;;
			--) shift; break;;
		esac
		shift
	done
# }	# ----------  end of function get_options  ----------

if [[ ! -d ${log_path} && ${script_log_name}"x" != "x" ]]; then
	log "log path: $log_path"
	log "log name: $script_log_name"
	mkdir -p ${log_path}
fi

main ()
{
	if [[ $1 == "env" ]]; then
		setup_env="env_base"
	elif [[ $1 == "vim" ]]; then
		setup_vim="vim"
	elif [[ $1 == "tmux" ]]; then
		setup_tmux="tmux"
	fi

	if [[ ${setup_env}"x" != "x" ]]; then
		${setup_env}_setup_env ${setup_quit} $@
	fi
	if [[ ${setup_vim}"x" != "x" ]]; then
		${setup_vim}_setup_env ${setup_quit} $@
	fi
	if [[ ${setup_tmux}"x" != "x" ]]; then
		${setup_tmux}_setup_env ${setup_quit} $@
	fi
	if [[ ${setup_compress}"x" != "x" ]]; then
		compress_part_vimfiles $@
	fi
	if [[ ${setup_build}"x" != "x" ]]; then
		${setup_build}_setup_env ${setup_quit} $@
	fi
	if [[ ${setup_extra}"x" != "x" ]]; then
		${setup_extra}_setup_env ${setup_quit} $@
	fi
}	# ----------  end of function main  ----------

main $@



