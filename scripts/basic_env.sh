#!/bin/bash -
#===============================================================================
#
#          FILE: basic_env.sh
#
#         USAGE: ./basic_env.sh
#
#   DESCRIPTION: base environment function
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Li Jin (JamesL), lij1@xiaopeng.com
#  ORGANIZATION: XPeng
#       CREATED: 12/30/2019 09:42:02 AM
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # treat unset variables as an error

## start general setup curent script env
## like script path, name etc.(source common.sh may overwrite it)
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
script_basename=$(basename $0)
script_path=$(dirname $($cmd_readlink "$0"))

## get current script path/name
if [[ ${top_dir}"x" == "x" ]]; then
	top_dir=${script_path}/..
fi

source ${top_dir}/scripts/common.sh
#########################################
## TODO
## define overwrite parameters here
#########################################

## end of general setup curent script env

cmd_realpath_ret=0
cmd_realpath="realpath"
${cmd_readlink} --help >/dev/null 2> /dev/null
if [[ $? != 0 ]]; then
   # cmd_realpath=
   cmd_realpath_ret=127
fi

## TODO
## plug manager base path
vim_plug_manager_path=$top_dir/common

replace_config()
{
	source_file=$1
	target_file=$2
	force_replace=$3

	if [[ ${cmd_realpath_ret} != 0 ]]; then
		loge "## do not have realpath!!, please check environment,"
	else
		source_real_path=`${cmd_realpath} ${source_file}`
		target_real_path=`${cmd_realpath} ${target_file}`

		logd "source path <${source_file}>, realpath: <${source_real_path}>"
		logd "target path <${target_file}>, realpath: <${target_real_path}>"

		if [[ -e ${source_file} ]]; then
			# if [[ ${target_real_path} == ${source_real_path} -a ${target_real_path}"x" != "x" ]]; then
			if [[ ${target_real_path} == ${source_real_path} ]]; then
				if [[ ${target_real_path}"x" != "x" ]]; then
					log "target path <${target_real_path}> is the same as source, do nothing"
					return 0
				fi
			fi
		fi
	fi

	## if no bk file, bk as origin file
	if [[ ! -e ${target_file}"_bk" ]]; then
		log "backing up ${target_file} to "${target_file}"_org"
		mv ${target_file} "${target_file}"_org
	fi

	if [[ ! -d ${target_file%'/'*} ]]; then
		mkdir -p ${target_file%'/'*}
	fi
	if [[ -e ${target_file} ]]; then
		if [[ -e "${target_file}"_bk ]]; then
			log "remove "${target_file}"_bk"
			rm -rf "${target_file}"_bk
		fi

		if [[ $force_replace == 1 ]]; then
			log "force replace target file"
			log "delete ${target_file}"
			rm -rf ${target_file}
		else
			log "backing up ${target_file} to "${target_file}"_bk"
			mv ${target_file} "${target_file}"_bk
		fi
	fi

	if [ ! -e ${source_file} ]; then
		echo "do not have source file, only backup target file"
		return 0
	fi
	echo "createing ${target_file}"
	if [[ "${system_type}" == msys || "${system_type}" == mingw ]]; then
		${script_path}/msys-ln.sh -s ${source_file} ${target_file}
	else
		ln -sf ${source_file} ${target_file}
	fi
}	# ----------  end of function replace_config ----------

init_git_config()
{
	log "=========== init_git_config ==============="
	## check git config
	git_user_name=`git config --get user.name`
	git_user_email=`git config --get user.email`
	if [[ "${git_user_name}x" == "x" ]]; then
		 git config --global user.name "james lee"
	fi

	if [[ "${git_user_email}x" == "x" ]]; then
		 git config --global user.email "princetemp@outlook.com"
	fi

	## disable windows filemode check
	if [[ ${system_type} == "ms-"* ]]; then
		git config --global core.filemode false
	fi
	if [[ ${system_type} == "msys" || ${system_type} == "mingw" ]]; then
		git config --global core.filemode false
	fi

	git config --global color.diff auto
	git config --global color.status auto
	git config --global color.branch auto
	git config --global color.interactive auto
}	# ----------  end of function init_git_config ----------

setup_powerline_shell()
{
	log "=========== setup_powerline_shell ==============="
	powerline_shell_path=$top_dir/env_base/base/powerline-shell
	if [[ ! -d $powerline_shell_path ]]; then
		return -1;
	fi

	cd $powerline_shell_path
	rm -rf 0*.patch
	cp $script_path/../patch/powerline-shell/*.patch $powerline_shell_path

	get_branch=`git branch 2>/dev/null |grep '\*'`
	branch=${get_branch:2}
	git_remote_version=`git remote -v|grep fetch|awk '{printf $2}'`
	if [[ $git_remote_version != "https://github.com/milkbikis/powerline-shell.git" ]]; then
		echo "current git is not powerline-shell"
		return
	fi
	git reset --hard
	if [[ $branch == "byjames" ]]; then
		git checkout master
		git branch -d byjames
	fi
	git branch byjames
	git checkout byjames
	git am -3 *.patch

	python3 setup.py install
}	# ----------  end of function setup_powerline_shell ----------

setup_plug_manager ()
{
	log "check and install vim-plug to ${vim_plug_manager_path}."
	if [ ! -d "${vim_plug_manager_path}" ]; then
		mkdir -p ${vim_plug_manager_path}
	fi
	cd ${vim_plug_manager_path}
	# download or update vundle in ./vimfiles/bundle/
	if [ ! -d "${vim_plug_manager_path}/vim-plug" ]; then
		git clone https://github.com/junegunn/vim-plug.git
	fi

	if [[ $system_type == "mac" ]]; then
		sed -i "" "s/--depth 1//g" ${vim_plug_manager_path}/vim-plug/plug.vim
		sed -i "" "s/--depth 99999999/--unshallow/g" ${vim_plug_manager_path}/vim-plug/plug.vim
		sed -i "" "s/--depth 999999/--unshallow/g" ${vim_plug_manager_path}/vim-plug/plug.vim
	else
		sed -i "s/--depth 1//g" ${vim_plug_manager_path}/vim-plug/plug.vim
		sed -i "s/--depth 99999999/--unshallow/g" ${vim_plug_manager_path}/vim-plug/plug.vim
		sed -i "s/--depth 999999/--unshallow/g" ${vim_plug_manager_path}/vim-plug/plug.vim
	fi

	cp -l ${vim_plug_manager_path}/vim-plug/plug.vim ${vim_plug_manager_path}/autoload/
}	# ----------  end of function install_plug_manager  ----------

vim_plug_get_packages ()
{
	vim_plug_conf_path=$1
	quite_after_install=$2

	vim_plug_param="-N "
	vim_plug_param+="-u ${vim_plug_conf_path}/vimrc.ins "

	vim_plug_action="+PlugClean "
	vim_plug_action+="+PlugUpdate "
	if [[ ${quite_after_install} == "quite" ]]; then
		vim_plug_action+="+qall "
	fi

	cd ${top_dir}
	vim ${vim_plug_param} \
		--cmd "set rtp=${vim_plug_manager_path}/,${vim_plug_manager_path}/base,${vim_plug_manager_path}/after,\$VIMRUNTIME " \
		${vim_plug_action}

}	# ----------  end of function vim_plug_get_packages  ----------







