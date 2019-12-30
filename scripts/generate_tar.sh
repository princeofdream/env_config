#!/bin/bash -
#===============================================================================
#
#          FILE: compact.sh
#
#         USAGE: ./compact.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2018年01月01日 21时47分11秒
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

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
script_basename=$(basename $0)
script_path=$(dirname $($cmd_readlink "$0"))

## get current script path/name
if [[ ${top_dir}"x" == "x" ]]; then
	top_dir=${script_path}/..
fi

source ${top_dir}/scripts/basic_env.sh
#########################################
## TODO
## define overwrite parameters here
#########################################

## end of general setup curent script env

file_name="rc.tar.bz2"
tmp_file_name="tmp.tar"

compress_vimfiles ()
{
	mv $top_dir/vimfiles/bundle/YouCompleteMe ./YouCompleteMe
	tar jchf rc.tar.bz2 vimfiles/
	mv $top_dir/YouCompleteMe $top_dir/vimfiles/bundle/YouCompleteMe
}	# ----------  end of function Compress_vimfiles  ----------


compress_part_vimfiles ()
{
	find ./vimfiles/ -maxdepth 1 -path ./vimfiles/bundle -prune -o -path ./vimfiles/ -o -print |awk -F, '{printf "\"%s\"\n",$1}'|xargs tar chf $tmp_file_name
	find ./vimfiles/bundle/ -maxdepth 1 -path ./vimfiles/bundle/YouCompleteMe -prune -o -path ./vimfiles/bundle/ -o -print |awk -F, '{printf "\"%s\"\n",$1}'|xargs tar rhf $tmp_file_name
	cat $tmp_file_name | bzip2 > $file_name
	rm $tmp_file_name
}	# ----------  end of function Compress_part_vimfiles  ----------




