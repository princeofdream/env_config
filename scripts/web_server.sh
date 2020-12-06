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
######### end setup env to get script path ############

script_path=$(dirname $($cmd_readlink "$0"))
top_path=${script_path}/..
source ${top_path}/common/common.sh
######### start setup basic script env ############
debug=0
log_path="${script_path}"
log_name="log_"$(basename $0)".log"
script_log_path=""
######### End Setup basic script env ############

######### Start Setup custom script env ############
######### End Setup custom script env ############

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


setup_gitweb_for_nginx ()
{
	return 0;
}	# ----------  end of function setup_gitweb_for_nginx  ----------

setup_gitweb_for_apache ()
{
	return 0;
}	# ----------  end of function setup_gitweb_for_apache  ----------

setup_gitweb_basic ()
{
	return 0;
}	# ----------  end of function setup_gitweb_basic  ----------

setup_gitweb ()
{
	return 0;
}	# ----------  end of function setup_gitweb  ----------




