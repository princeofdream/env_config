#===============================================================================
#
#          FILE: shellcommon.sh
#
#         USAGE: source bash_extern_rc.sh
#
#   DESCRIPTION: bash extern rc environment
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2018年03月30日 09时01分19秒
#      REVISION:  ---
#===============================================================================

config_debug=0
config_log_count=0
config_log_color="true"
config_log_dir="${script_path}"
config_log_name="log_bash.log"
config_log_path=""
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




USE_LLVM_FOR_ARM=false


USE_EXTERN_JAVA_ENV=true
USE_EXTERN_ANT_ENV=true
USE_EXTERN_MAVEN_ENV=true
USE_EXTERN_TOMCAT_ENV=true
USE_EXTERN_OPENGROK_ENV=true
USE_EXTERN_WEB_BASE_ENV=true
USE_EXTERN_ROOTFS_ENV=true
USE_EXTERN_ROOTFS_USR_ENV=true
USE_EXTERN_ROOTFS_USR_LOCAL_ENV=true
USE_EXTERN_TOOLCHAIN_ENV=true
USE_EXTERN_ANDROID_ENV=true

USE_EXTERN_LD_PATH_ENV=false
USE_EXTERN_LD_PATH_USR_ENV=false
USE_EXTERN_PKG_PATH_ENV=false
USE_EXTERN_PKG_PATH_USR_ENV=false

USE_SYSTEM_C_INCLUDE_PATH_ENV=true
USE_EXTERN_C_INCLUDE_PATH_USR_ENV=true

############# !!!! ###############
USE_SYSTEM_LD_PKG_CONFIG_FIRST=false


############ Basic PATH variable #############
PATH_TOOLCHAIN_BASE=$HOME/envx/toolchain
PATH_TOOLCHAIN_GCC_BASE=$PATH_TOOLCHAIN_BASE/gcc
PATH_TOOLCHAIN_JDK_BASE=$PATH_TOOLCHAIN_BASE/jdk

PATH_WEB_BASE=$HOME/envx/web_base

PATH_ENV_ROOTFS_BASE=$HOME/envx/env_rootfs
# config_lsb_release=$(lsb_release -i 2>/dev/null |awk -F ':' '{print $2}'| sed -e 's/^[ \t]*//g')
# config_lsb_release=${config_lsb_release,,}
config_lsb_release=$(cat /etc/os-release | grep -i "^NAME" 2>/dev/null |awk -F '=' '{print $2}'| tr '[A-Z]' '[a-z]' |xargs echo)
config_lsb_release=${config_lsb_release%% *}

if [[ "${config_lsb_release}" == "" ]]; then
	PATH_ENV_ROOTFS_BASE=$HOME/envx/env_rootfs
else
	PATH_ENV_ROOTFS_BASE=$HOME/envx/env_rootfs_${config_lsb_release}
fi

# if [[ -e "${HOME}/.wine" || -h "${HOME}/.wine" ]]; then
#     CONFIG_WINE_LINK=$(ls $HOME/.wine -dl --time-style=+%Y|grep -i "${config_lsb_release}$" 2>/dev/null)
#     if [[ -h "${HOME}/.wine" ]]; then
#         if [[ "${CONFIG_WINE_LINK}" == "" ]]; then
#             rm ${HOME}/.wine
#             ln -s ${HOME}/.wine_${config_lsb_release} ${HOME}/.wine
#         fi
#     elif [[ -d "${HOME}/.wine" ]]; then
#         CONFIG_WINE_DIR_LIST=$(ls -d ${HOME}/.wine_unknow* 2>/dev/null | tail -1)
#         CONFIG_WINE_DIR_COUNT=$(printf "%d" ${CONFIG_WINE_DIR_LIST:0-2})
#         CONFIG_WINE_DIR_COUNT=$(($CONFIG_WINE_DIR_COUNT + 1))
#         CONFIG_WINE_DIR_COUNT=$(printf "%02d" $CONFIG_WINE_DIR_COUNT)
#         mv ${HOME}/.wine ${HOME}/.wine_unknow_${CONFIG_WINE_DIR_COUNT}
#     fi
# fi

# if [[ ! -e "${HOME}/.wine" && ! -h "${HOME}/.wine" ]]; then
#     ln -s ${HOME}/.wine_${config_lsb_release} ${HOME}/.wine
# fi

############# #Select  Terminal Color support ##################
# Select --> tmux / tmux-xterm / tmux-screen / tmux-st / none
# ENABLE_TRUE_COLOR="tmux-xterm"
ENABLE_TRUE_COLOR="tmux-screen"
# ENABLE_TRUE_COLOR="screen256"
# ENABLE_TRUE_COLOR="false"

SYSTEM_NAME=`uname -a`
SYSTEM_TYPE="linux"
SUB_SYSTEM_TYPE=""

case "${SYSTEM_NAME}" in
	"MSYS"* )
		SYSTEM_TYPE="msys";
		;;
	"MINGW64"* )
		SYSTEM_TYPE="mingw64"
		;;
	"MINGW32"* )
		SYSTEM_TYPE="mingw32"
		;;
	*"Microsoft"*"Linux"* )
		SYSTEM_TYPE="ms-linux"
		;;
	*"microsoft"*"WSL2"*"Linux"* )
		SYSTEM_TYPE="ms-linux"
		;;
	*"Darwin"* )
		SYSTEM_TYPE="mac"
		;;
	*"Ubuntu"* | *"kylin"* )
		SUB_SYSTEM_TYPE="ubuntu"
		;;
esac

SIMPLE_COLOR="${SIMPLE_COLOR}"

case "${SYSTEM_TYPE}" in
	linux )
		if [[ $DISPLAY == "" && $SSH_CONNECTION == "" ]]; then
				USE_SIMPLE_COLOR=true
		fi
		;;
	mac )
		USE_SIMPLE_COLOR=false
		;;
	msys | "mingw"* )
		USE_SIMPLE_COLOR=false
		;;
	"ms-linux" )
		USE_SIMPLE_COLOR=false
		;;
esac

if [[ "${SIMPLE_COLOR}" == "false" ]]; then
	USE_SIMPLE_COLOR="${SIMPLE_COLOR}"
fi

if [[ "${USE_SIMPLE_COLOR}" == "true" ]]; then
	ENABLE_POWERLINE="none"
	ENABLE_TRUE_COLOR="false"
	SIMPLE_COLOR="true"
else
	SIMPLE_COLOR="false"
fi

switch_java_sdk ()
{
	TYPE=$1
	VERSION=$2

	export JAVA_HOME="$PATH_TOOLCHAIN_JDK_BASE/$TYPE-$VERSION"
	export JRE_HOME="$JAVA_HOME/jre"
	export CLASSPATH=".:$JAVA_HOME/lib:$JRE_HOME/lib:$PATH_ENV_ROOTFS_BASE/lib:$CLASSPATH"
	PATH="$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH"
}	# ----------  end of function switch_java_sdk  ----------

append_path_env ()
{
	add_path=$1
	# str1 not contain str2
	# log "adding [ ${add_path} ]"
	if [[ ! -e "${add_path}" ]]; then
		# logw "[ ${add_path} ] not exist"
		return 0
	fi

	if [[ ! ${ORIGIN_PATH}"" =~ ${add_path}"" ]]; then
		if [[ ${PATH}"" != "" ]]; then
			PATH+=":"
		fi
		PATH+="$add_path"
	fi
}	# ----------  end of function append_path_env  ----------

append_path_priority_env ()
{
	add_path=$1
	# str1 not contain str2
	# log "adding [ ${add_path} ]"
	if [[ ! -e "${add_path}" ]]; then
		# logw "[ ${add_path} ] not exist"
		return 0
	fi

	if [[ ! ${ORIGIN_PATH}"" =~ ${add_path}"" ]]; then
		if [[ "${PATH}" != "" ]]; then
			PATH="${add_path}:$PATH"
		else
			PATH="${add_path}${PATH}"
		fi
	fi
}	# ----------  end of function append_path_priority_env  ----------

append_classpath_env ()
{
	add_path=$1
	# str1 not contain str2
	if [[ ! ${ORIGIN_CLASSPATH}"" =~ ${add_path}"" ]]; then
		if [[ ${CLASSPATH}"" != "" ]]; then
			CLASSPATH+=":"
		fi
		CLASSPATH+="$add_path"
	fi
}	# ----------  end of function append_classpath_env  ----------

get_message_length ()
{
	SRC_PARAM="$@"
	echo "${#SRC_PARAM}"
}	# ----------  end of function get_message_length  ----------

####################################################################
ORIGIN_CLASSPATH=$CLASSPATH

ORIGIN_PATH=$PATH:/sbin:/bin:/usr/bin:/usr/sbin:/usr/sbin:/usr/local/sbin
if [[ ${SYSTEM_TYPE}"" == "mac" ]]; then
	ORIGIN_PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi
case "${SYSTEM_TYPE}" in
	msys | "mingw"* | "ms-linux" )
		ORIGIN_PATH=${ORIGIN_PATH//\ /_}
		ORIGIN_PATH=${ORIGIN_PATH// /_}
		;;
esac

############# #Jave env ##################
if [[ ${USE_EXTERN_JAVA_ENV}"" == "true" ]]; then
	# JAVA_HOME="/usr/lib/jvm/default-java"
	JAVA_HOME="$PATH_TOOLCHAIN_JDK_BASE/default-java"
	JRE_HOME=$JAVA_HOME/jre

	append_classpath_env "."
	append_classpath_env "$JAVA_HOME/lib"
	append_classpath_env "$JRE_HOME/lib"
	append_classpath_env "$PATH_ENV_ROOTFS_BASE/lib"

	append_path_priority_env "$JAVA_HOME/bin"
	append_path_priority_env "$JAVA_HOME/jre/bin"
fi

############# #ant env ##################
if [[ ${USE_EXTERN_ANT_ENV}"" == "true" ]]; then
	# ANT_HOME="$PATH_ENV_ROOTFS_BASE"
	ANT_HOME="$PATH_TOOLCHAIN_JDK_BASE/apache-ant"

	append_classpath_env "$ANT_HOME/lib"
	append_path_priority_env "$ANT_HOME/bin"
fi

############# #mvn env ##################
if [[ ${USE_EXTERN_MAVEN_ENV}"" == "true" ]]; then
	# M2_HOME="$PATH_ENV_ROOTFS_BASE"
	M2_HOME="$PATH_TOOLCHAIN_JDK_BASE/apache-maven"

	append_classpath_env "$M2_HOME/lib"
	append_path_priority_env "$M2_HOME/bin"
fi

############# #tomcat env ##################
if [[ ${USE_EXTERN_TOMCAT_ENV}"" == "true" ]]; then
	CATALINA_BASE="$PATH_WEB_BASE/apache-tomcat"
	CATALINA_HOME="$CATALINA_BASE/"
	CATALINA_PID="$CATALINA_BASE/tomcat.pid"

	append_classpath_env "$CATALINA_BASE/lib"
	append_path_priority_env "$CATALINA_BASE/bin"
fi

############# #tomcat env ##################
if [[ ${USE_EXTERN_OPENGROK_ENV}"" == "true" ]]; then
	export OPENGROK_TOMCAT_BASE=$CATALINA_BASE
	export OPENGROK_APP_SERVER=Tomcat
	export OPENGROK_INSTANCE_BASE=$PATH_WEB_BASE/opengrok
fi


LLVM_ARM_ROOT=$PATH_TOOLCHAIN_GCC_BASE/snapdragon-llvm
LLVM_ORIGIN_ROOT=$PATH_ENV_ROOTFS_BASE
LLVMROOT=$LLVM_ARM_ROOT
LLVMBIN=$LLVMROOT/bin

if [[ ${USE_LLVM_FOR_ARM}"" == "true" ]]; then
	##### llvm runtime #####
	append_path_priority_env "$LLVM_ARM_ROOT/bin"
fi

append_path_priority_env "$HOME/.cargo/bin"

############# #Web_Base env ##################
if [[ ${USE_EXTERN_WEB_BASE_ENV}"" == "true" ]]; then
	##### web_base runtime #####
	append_path_priority_env "$PATH_WEB_BASE/bin"
	append_path_priority_env "$PATH_WEB_BASE/sbin"
	append_path_priority_env "$PATH_WEB_BASE/man"
fi

############# #Fake rootfs env ##################
if [[ ${USE_EXTERN_ROOTFS_ENV}"" == "true" ]]; then
	##### env_rootfs runtime #####
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/bin"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/sbin"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/man"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/libexec"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/libexec/git-core"
fi

############# #Fake rootfs usr env ##################
if [[ ${USE_EXTERN_ROOTFS_USR_ENV}"" == "true" ]]; then
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/bin"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/sbin"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/man"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/libexec"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/libexec/git-core"
fi

############# #Fake rootfs usr local env ##################
if [[ ${USE_EXTERN_ROOTFS_USR_LOCAL_ENV}"" == "true" ]]; then
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/local/bin"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/local/sbin"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/local/man"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/local/libexec"
	append_path_priority_env "$PATH_ENV_ROOTFS_BASE/usr/local/libexec/git-core"
fi

############# #Origin PATH env ##################
# if [[ ${PATH}"" != "" ]]; then
#     PATH+=":"
# fi
# PATH+="$ORIGIN_PATH"
CLASSPATH+="$ORIGIN_CLASSPATH"

############# #Extern toolchain env ##################
if [[ ${USE_EXTERN_TOOLCHAIN_ENV}"" == "true" ]]; then
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/toolchain-openwrt-arm/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/toolchain-openwrt-aarch64/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/arm-linux-androideabi/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-arm-eabi/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-arm-linux-gnueabi/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-arm-linux-gnueabihf/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-aarch64-linux-gnu/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-aarch64-none-elf/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-arm-aarch64-none-elf/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/devkitA64/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/devkitPPC/bin"
	append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/devkitARM/bin"
fi

############# #Extern Android env ##################
if [[ ${USE_EXTERN_ANDROID_ENV}"" == "true" ]]; then
	# append_path_priority_env "$PATH_TOOLCHAIN_GCC_BASE/arm-2010q1/bin"
	append_path_priority_env "$HOME/envx/android/sdk/platform-tools"
	append_path_priority_env "$HOME/envx/android/android-ndk"
	ANDROID_HOME="$HOME/envx/android/sdk"
fi

if [[ -e "$HOME/.local/bin" ]]; then
	append_path_priority_env "$HOME/.local/bin"
fi
if [[ -e "$HOME/.local/sbin" ]]; then
	append_path_priority_env "$HOME/.local/sbin"
fi

############# #Extern gcc env ##################
if [[ -e $PATH_TOOLCHAIN_GCC_BASE/gcc ]]; then
	append_path_priority_env ${PATH_TOOLCHAIN_GCC_BASE}/gcc/bin
fi


############# #Extern golang env ##################
if [[ -e $HOME/envx/toolchain/go ]]; then
	export GOROOT=$HOME/envx/toolchain/go/go
	export GOPATH=$HOME/envx/toolchain/go/go/thirdpart
	export GOPROXY='https://goproxy.cn,direct'
	append_path_priority_env ${GOROOT}/bin
	append_path_priority_env ${GOPATH}/bin
fi

############# #Extern ndk env ##################
ndk_path=$HOME/envx/toolchain/ndk/android-ndk
ndk_llvm_path=${ndk_path}/toolchains/llvm/prebuilt/linux-x86_64
if [[ -e ${ndk_path} ]]; then
	export NDK=${ndk_path}
	append_path_priority_env ${ndk_llvm_path}/bin
	append_path_priority_env ${ndk_llvm_path}/bin
fi

############# #Terminal Color Support ##################
TERM_ORG=${TERM}
if [[ ${ENABLE_TRUE_COLOR}"" == "tmux-xterm" ]]; then
	alias tmux="env TERM=xterm-256color tmux"
	# TERM="xterm-256color"
	TERM="screen-256color"
elif [[ ${ENABLE_TRUE_COLOR}"" == "tmux-screen" ]]; then
	alias tmux="env TERM=screen-256color tmux"
	TERM="screen-256color"
elif [[ ${ENABLE_TRUE_COLOR}"" == "tmux-st" ]]; then
	TERM="st-256color"
elif [[ ${ENABLE_TRUE_COLOR}"" == "screen256" ]]; then
	TERM="screen-256color"
elif [[ ${ENABLE_TRUE_COLOR}"" == "false" ]]; then
	TERM="xterm"
else
	TERM="screen-256color"
fi

# if [[ ! -n ${TMUX}"" ]]; then
#     TERM=${TERM_ORG}
# fi

############# #LD_LIBRARY_PATH env ##################
if [[ ${LD_LIBRARY_PATH}"" == "" || ${LD_LIBRARY_PATH}"" == "/home"* ]]; then
	SYSTEM_LD_LIBRARY_PATH="/lib:/lib64:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64"
	if [[ ${SUB_SYSTEM_TYPE}"" == "ubuntu" ]]; then
		SYSTEM_ARCH=`uname -p`
		SYSTEM_LD_LIBRARY_PATH="/lib/${SYSTEM_ARCH}-linux-gnu:"$SYSTEM_LD_LIBRARY_PATH
	fi
else
	SYSTEM_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
fi
if [[ ${USE_EXTERN_LD_PATH_ENV}"" == "true" ]]; then
	EXTERN_LD_LIBRARY_PATH="$PATH_ENV_ROOTFS_BASE/lib"
	EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/lib64"
fi
if [[ ${USE_EXTERN_LD_PATH_USR_ENV}"" == "true" ]]; then
	if [[ ${EXTERN_LD_LIBRARY_PATH}"" == "" ]]; then
		EXTERN_LD_LIBRARY_PATH="$PATH_ENV_ROOTFS_BASE/usr/lib"
	else
		EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib"
	fi
	EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib64"
	EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/local/lib"
	EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/local/lib64"
fi

## Set LD_LIBRARY_PATH
LD_LIBRARY_PATH_SYSTEM_FIRST="$SYSTEM_LD_LIBRARY_PATH"
LD_LIBRARY_PATH_CUSTOM_FIRST="$SYSTEM_LD_LIBRARY_PATH"
if [[ ! ${EXTERN_LD_LIBRARY_PATH}"" == "" ]]; then
	LD_LIBRARY_PATH_SYSTEM_FIRST+=":$EXTERN_LD_LIBRARY_PATH"
	LD_LIBRARY_PATH_CUSTOM_FIRST="$EXTERN_LD_LIBRARY_PATH:$LD_LIBRARY_PATH_CUSTOM_FIRST"
fi

if [[ ${USE_SYSTEM_LD_PKG_CONFIG_FIRST}"" == "true" ]]; then
	LD_LIBRARY_PATH="$LD_LIBRARY_PATH_SYSTEM_FIRST"
else
	LD_LIBRARY_PATH="$LD_LIBRARY_PATH_CUSTOM_FIRST"
fi

############# #PKG_CONFIG_PATH env ##################
if [[ ${PKG_CONFIG_PATH}"" == "" || ${PKG_CONFIG_PATH} == "/home"* ]]; then
	SYSTEM_PKG_CONFIG_PATH="/lib:/lib64:/usr/lib:/usr/lib64"
	SYSTEM_PKG_CONFIG_PATH+=":/lib/pkgconfig:/lib64/pkgconfig:/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/local/lib/pkgconfig"
else
	SYSTEM_PKG_CONFIG_PATH=$PKG_CONFIG_PATH
fi
if [[ ${USE_EXTERN_PKG_PATH_ENV}"" == "true" ]]; then
	EXTERN_PKG_CONFIG_PATH="$PATH_ENV_ROOTFS_BASE/lib"
	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/lib64"
	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/lib/pkgconfig"
	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/lib64/pkgconfig"
fi
if [[ ${USE_EXTERN_PKG_PATH_USR_ENV}"" == "true" ]]; then
	if [[ ${EXTERN_PKG_CONFIG_PATH}"" == "" ]]; then
		EXTERN_PKG_CONFIG_PATH="$PATH_ENV_ROOTFS_BASE/usr/lib"
	else
		EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib"
	fi

	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib64"
	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/local/lib"

	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib/pkgconfig"
	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/local/lib/pkgconfig"
	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib64/pkgconfig"
fi

## Set PKG_CONFIG_PATH
PKG_CONFIG_PATH_SYSTEM_FIRST="$SYSTEM_PKG_CONFIG_PATH"
PKG_CONFIG_PATH_CUSTOM_FIRST="$SYSTEM_PKG_CONFIG_PATH"
if [[ ! ${EXTERN_PKG_CONFIG_PATH}"" == "" ]]; then
	PKG_CONFIG_PATH_SYSTEM_FIRST+=":$EXTERN_PKG_CONFIG_PATH"
	PKG_CONFIG_PATH_CUSTOM_FIRST="$EXTERN_PKG_CONFIG_PATH:$PKG_CONFIG_PATH_CUSTOM_FIRST"
fi
if [[ ${USE_SYSTEM_LD_PKG_CONFIG_FIRST}"" == "true" ]]; then
	PKG_CONFIG_PATH="$PKG_CONFIG_PATH_SYSTEM_FIRST"
else
	PKG_CONFIG_PATH="$PKG_CONFIG_PATH_CUSTOM_FIRST"
fi

ORIGIN_PATH=$PATH
ORIGIN_CLASSPATH=$CLASSPATH
SNAPDRAGON_PATH=$PATH_TOOLCHAIN_GCC_BASE/snapdragon-llvm/bin:$PATH

############# #C_INCLUDE_PATH env ##################
if [[ ${C_INCLUDE_PATH}"" != "" ]]; then
	SYSTEM_C_INCLUDE_PATH=$C_INCLUDE_PATH
fi
if [[ ${USE_SYSTEM_C_INCLUDE_PATH_ENV}"" == "true" ]]; then
	if [[ ${EXTERN_C_INCLUDE_PATH}"" == "" ]]; then
		EXTERN_C_INCLUDE_PATH="/usr/include"
	else
		EXTERN_C_INCLUDE_PATH+=":/usr/include"
	fi

	EXTERN_C_INCLUDE_PATH+=":/usr/local/include"
fi
if [[ ${USE_EXTERN_C_INCLUDE_PATH_USR_ENV}"" == "true" ]]; then
	if [[ ${EXTERN_C_INCLUDE_PATH}"" == "" ]]; then
		EXTERN_C_INCLUDE_PATH="./include"
	else
		EXTERN_C_INCLUDE_PATH+=":./include"
	fi

	EXTERN_C_INCLUDE_PATH+=":../include"
fi

## Set C_INCLUDE_PATH
if [[ ${SYSTEM_C_INCLUDE_PATH}"" == "" ]]; then
	C_INCLUDE_PATH="${EXTERN_C_INCLUDE_PATH}"
else
	C_INCLUDE_PATH="${SYSTEM_C_INCLUDE_PATH}"
	C_INCLUDE_PATH+=":${EXTERN_C_INCLUDE_PATH}"
fi

## Set CPLUS_INCLUDE_PATH
CPLUS_INCLUDE_PATH="${C_INCLUDE_PATH}"

usage_shell ()
{
	printf "custom usage:\n
	sudo='sudo env PATH=\$PATH SIMPLE_COLOR=\$SIMPLE_COLOR LD_LIBRARY_PATH=\$LD_LIBRARY_PATH_SYSTEM_FIRST PKG_CONFIG_PATH=\$PKG_CONFIG_PATH_SYSTEM_FIRST TERM=xterm'
	sdo='sudo env PATH=\$PATH SIMPLE_COLOR=\$SIMPLE_COLOR LD_LIBRARY_PATH=\$LD_LIBRARY_PATH_CUSTOM_FIRST PKG_CONFIG_PATH=\$PKG_CONFIG_PATH_CUSTOM_FIRST TERM=xterm'
	yum='env LD_LIBRARY_PATH=\$LD_LIBRARY_PATH_SYSTEM_FIRST PKG_CONFIG_PATH=\$PKG_CONFIG_PATH_SYSTEM_FIRST yum'

	rq='PROMPT_COMMAND=\"_update_ps1\"'
	s.openjdk_6='echo \"switch_java_sdk openjdk 6\" ;switch_java_sdk \"openjdk\" \"6\"'
	s.openjdk_7='echo \"switch_java_sdk openjdk 7\" ;switch_java_sdk \"openjdk\" \"7\"'
	s.openjdk_8='echo \"switch_java_sdk openjdk 8\" ;switch_java_sdk \"openjdk\" \"8\"'
	s.openjdk_9='echo \"switch_java_sdk openjdk 9\" ;switch_java_sdk \"openjdk\" \"9\"'
	s.jdk_6='echo \"switch_java_sdk jdk 6\" ; switch_java_sdk \"jdk\" \"6\"'
	s.jdk_7='echo \"switch_java_sdk jdk 7\" ; switch_java_sdk \"jdk\" \"7\"'
	s.jdk_8='echo \"switch_java_sdk jdk 8\" ; switch_java_sdk \"jdk\" \"8\"'
	s.jdk_9='echo \"switch_java_sdk jdk 9\" ; switch_java_sdk \"jdk\" \"9\"'

	s.py2
	s.py3
	\n"
	return 0;
}	# ----------  end of function shell_usage  ----------


s_py2 ()
{
	local var_python_path
	local var_cur_py_ver
	local var_force=$1

	if [[ "${var_force}" == "-f" || "${var_force}" == "" ]]; then
		var_force=true
	else
		var_force=false
	fi
	var_python_path=/usr/bin/python2
	if [[ ! -x /usr/bin/python2 ]]; then
		var_python_path=$(whereis python2 |awk '{print $2}')
	fi

	var_cur_py_ver=$(python --version 2>&1|awk '{print $2}'|awk -F"." '{print $1}' 2>/dev/null)
	if [[ "${var_cur_py_ver}" == "2" && "${var_force}" != "true" ]]; then
		return
	fi

	if [[ ! -d "$HOME/envx/pyenv/py2env" ]]; then
		virtualenv -p ${var_python_path} $HOME/envx/pyenv/py2env
	else
		source $HOME/envx/pyenv/py2env/bin/activate
		python --version >/dev/null 2>/dev/null
		if [[ $? -ne 0 ]]; then
			mv $HOME/envx/pyenv/py2env $HOME/envx/pyenv/py2env.$(date +%Y%m%d_%H%M%S)
			virtualenv -p /usr/bin/python2 $HOME/envx/pyenv/py2env
		fi
		return 0
	fi
	source $HOME/envx/pyenv/py2env/bin/activate
	return 0;
}	# ----------  end of function s_py2  ----------

s_py3 ()
{
	local var_python_path
	local var_cur_py_ver
	local var_force=$1

	if [[ "${var_force}" == "-f" || "${var_force}" == "" ]]; then
		var_force=true
	else
		var_force=false
	fi

	var_python_path=/usr/bin/python3
	if [[ ! -x /usr/bin/python3 ]]; then
		var_python_path=$(whereis python3 |awk '{print $2}')
	fi

	var_cur_py_ver=$(python --version 2>&1 |awk '{print $2}'|awk -F"." '{print $1}' 2>/dev/null)
	if [[ "${var_cur_py_ver}" == "3" && "${var_force}" != "true" ]]; then
		return 0
	fi

	if [[ ! -d "$HOME/envx/pyenv/py3env" ]]; then
		virtualenv -p ${var_python_path} $HOME/envx/pyenv/py3env
	else
		source $HOME/envx/pyenv/py3env/bin/activate
		python --version >/dev/null 2>/dev/null
		if [[ $? -ne 0 ]]; then
			mv $HOME/envx/pyenv/py3env $HOME/envx/pyenv/py3env.$(date +%Y%m%d_%H%M%S)
			virtualenv -p /usr/bin/python3 $HOME/envx/pyenv/py3env
		fi
		return 0
	fi
	source $HOME/envx/pyenv/py3env/bin/activate
	return 0;
}	# ----------  end of function s_py3  ----------

s_go ()
{
	local var_go_ver=$1
	local var_go_path="$HOME/envx/toolchain/go"
	local var_go_info=""

	if [[ "${var_go_ver}" == "" ]]; then
		logw "usage: s_go 1.20"
		return 100;
	fi
	if [[ ! -e "${var_go_path}/go.${var_go_ver}" ]]; then
		logw "go ${var_go_ver}/go.${var_go_ver} not exist!"

		var_go_info=$(ls ${var_go_path}|grep "go.${var_go_ver}"|tail -1)
		if [[ "${var_go_info}" == "" ]]; then
			logw "no extra version for go.${var_go_ver}"
			return 100
		fi
		logw "try set to [${var_go_info}]"
		var_go_ver=${var_go_info#*.}
	fi

	log "switch go to ${var_go_ver}"
	export GOROOT=${var_go_path}/go.${var_go_ver}
	export GOPATH=${GOROOT}/thirdpart
	export GOPROXY='https://goproxy.cn,direct'
	append_path_priority_env ${GOROOT}/bin
	append_path_priority_env ${GOPATH}/bin

}	# ----------  end of function s_go  ----------

############# #sudo env ##################
alias sudo='sudo env PATH=$PATH SIMPLE_COLOR=${SIMPLE_COLOR} LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SYSTEM_FIRST PKG_CONFIG_PATH=$PKG_CONFIG_PATH_SYSTEM_FIRST TERM=xterm'
alias sdo='sudo env PATH=$PATH SIMPLE_COLOR=${SIMPLE_COLOR} LD_LIBRARY_PATH=$LD_LIBRARY_PATH_CUSTOM_FIRST PKG_CONFIG_PATH=$PKG_CONFIG_PATH_CUSTOM_FIRST TERM=xterm'
alias yum='env LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SYSTEM_FIRST PKG_CONFIG_PATH=$PKG_CONFIG_PATH_SYSTEM_FIRST yum'

alias rq='PROMPT_COMMAND="_update_ps1"'
alias s.openjdk_6='echo "switch_java_sdk openjdk 6" ;switch_java_sdk "openjdk" "6"'
alias s.openjdk_7='echo "switch_java_sdk openjdk 7" ;switch_java_sdk "openjdk" "7"'
alias s.openjdk_8='echo "switch_java_sdk openjdk 8" ;switch_java_sdk "openjdk" "8"'
alias s.openjdk_9='echo "switch_java_sdk openjdk 9" ;switch_java_sdk "openjdk" "9"'
alias s.jdk_6='echo "switch_java_sdk jdk 6" ; switch_java_sdk "jdk" "6"'
alias s.jdk_7='echo "switch_java_sdk jdk 7" ; switch_java_sdk "jdk" "7"'
alias s.jdk_8='echo "switch_java_sdk jdk 8" ; switch_java_sdk "jdk" "8"'
alias s.jdk_9='echo "switch_java_sdk jdk 9" ; switch_java_sdk "jdk" "9"'

alias s.path_origin='export PATH=$ORIGIN_PATH'
alias s.classpath_origin='export CLASSPATH=$ORIGIN_CLASSPATH'
alias s.path_snapdragon='export PATH=$SNAPDRAGON_PATH && export LLVMROOT=$LLVM_ARM_ROOT && export LLVMBIN=$LLVMROOT/bin'

alias s.py2='s_py2'
alias s.py3='s_py3'
alias s.go='s_go'
# alias tmux='pmux'

utils_find_c ()
{
	f_param=$@

	k_param="-iname \"*.c\""
	k_param=${k_param}" -o -iname \"*.h\""
	k_param=${k_param}" -type f"

	if [[ ${f_param}"" == *-name* || ${f_param}"" == *-iname* ]]; then
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} "-o" ${k_param}
	else
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} ${k_param}
	fi
	return $?
}	# ----------  end of function utils_find_c  ----------

utils_find_cxx ()
{
	f_param=$@

	k_param="-iname \"*.c\""
	k_param=${k_param}" -o -iname \"*.h\""
	k_param=${k_param}" -o -iname \"*.cpp\""
	k_param=${k_param}" -o -iname \"*.cc\""
	k_param=${k_param}" -o -iname \"*.hpp\""
	k_param=${k_param}" -type f"

	if [[ ${f_param}"" == *-name* || ${f_param}"" == *-iname* ]]; then
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} "-o" ${k_param}
	else
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} ${k_param}
	fi
	return $?
}	# ----------  end of function utils_find_cxx  ----------

utils_find_cpp ()
{
	f_param=$@

	k_param="-iname \"*.cpp\""
	k_param=${k_param}" -o -iname \"*.hpp\""
	k_param=${k_param}" -type f"

	if [[ ${f_param}"" == *-name* || ${f_param}"" == *-iname* ]]; then
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} "-o" ${k_param}
	else
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} ${k_param}
	fi
	return $?
}	# ----------  end of function utils_find_cpp  ----------

utils_find_java ()
{
	f_param=$@

	k_param="-iname \"*.java\""
	k_param=${k_param}" -type f"

	if [[ ${f_param}"" == *-name* || ${f_param}"" == *-iname* ]]; then
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} "-o" ${k_param}
	else
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} ${k_param}
	fi
	return $?
}	# ----------  end of function utils_find_java  ----------

utils_find_sh ()
{
	f_param=$@

	k_param="-iname \"*.sh\""
	k_param=${k_param}" -o -iname \"*.bash\""
	k_param=${k_param}" -type f"

	if [[ ${f_param}"" == *-name* || ${f_param}"" == *-iname* ]]; then
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} "-o" ${k_param}
	else
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} ${k_param}
	fi
	return $?
}	# ----------  end of function utils_find_sh  ----------

utils_find_mk ()
{
	f_param=$@

	k_param="-iname \"*.mk\""
	k_param=${k_param}" -o -iname \"Makefile\""
	k_param=${k_param}" -o -iname \"Android.bp\""
	k_param=${k_param}" -type f"

	if [[ ${f_param}"" == *-name* || ${f_param}"" == *-iname* ]]; then
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} "-o" ${k_param}
	else
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} ${k_param}
	fi
	return $?
}	# ----------  end of function utils_find_sh  ----------

utils_find_grep_common ()
{
	local var_param_type=$1
	local var_param_var=$2
	local var_debug=false

	if [[ "${var_param_type}" == "" ]]; then
		var_param_type=file
	else
		shift
	fi

	if [[ "${var_param_var}" == "-d" ]]; then
		var_debug=true
		shift
	fi

	if [[ "$@" == "" ]]; then
		if [[ "${var_debug}" == "true" ]]; then
			echo "utils_find_${var_param_type} |awk \'{print \"\\\"\"$0\"\"\\\"\"}\'"
		fi
		eval utils_find_${var_param_type} |awk '{print "\""$0"\""}'
	else
		if [[ "${var_debug}" == "true" ]]; then
			echo "utils_find_${var_param_type} |awk \'{print \"\\\"\"$0\"\\\"\"}\' |xargs grep $@"
		fi
		eval utils_find_${var_param_type} |awk '{print "\""$0"\""}' | xargs grep $@
	fi
}

utils_find_tar ()
{
	f_param=$@

	k_param="-iname \"*.gz\""
	k_param=${k_param}" -o -iname \"*.tar\""
	k_param=${k_param}" -o -iname \"*.tar.*\""
	k_param=${k_param}" -o -iname \"*.bz2\""
	k_param=${k_param}" -o -iname \"*.xz\""
	k_param=${k_param}" -o -iname \"*.cpio\""
	k_param=${k_param}" -type f"

	if [[ ${f_param}"" == *-name* || ${f_param}"" == *-iname* ]]; then
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m-o ${k_param} [0m"
		fi
		eval find ${f_param} "-o" ${k_param}
	else
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} ${k_param}
	fi
	return $?
}	# ----------  end of function utils_find_sh  ----------

utils_find_file ()
{
	f_param=$@

	# k_param="-iname \"*.sh\""
	# k_param=${k_param}" -o -iname \"*.bash\""
	k_param="-type f"

	if [[ ${f_param}"" == *-name* || ${f_param}"" == *-iname* ]]; then
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} "-o" ${k_param}
	else
		if [[ "${log_debug}" != "" ]]; then
			echo -e "[0;34;1mfind [0m[0;32;1m${f_param} [0m[0;33;1m${k_param} [0m"
		fi
		eval find ${f_param} ${k_param}
	fi
	return $?
}	# ----------  end of function utils_find_sh  ----------


utils_while_loop ()
{
	local var_cmd="$@"
	local var_delay=1;
	local var_loop=0;

	if [[ "$1" == "-d" || "$1" == "--delay" ]]; then
		var_delay=$2
		shift;
		shift;
		var_cmd="$@"
	fi
	echo "delay [ ${var_delay}s ] for eatch loop."

	while true;
	do
		eval "${var_cmd}"
		log "---[loop:${var_loop}][$(date +%Y%m%d_%H%M%S): ${var_delay}s]->[${var_cmd}]---"
		if [[ ${var_delay} -lt 1 ]]; then
			var_delay=1
		fi
		var_loop=$((${var_loop} + 1))
		sleep $var_delay
	done
}	# ----------  end of function utils_while_loop  ----------

alias bash='TERM=xterm bash'

ncdu --color dark 2>/dev/null >/dev/null
if [[ $? -eq 0 ]]; then
	alias ncdu='ncdu --color dark -rr -x --exclude .git --exclude node_modules'
fi
alias a_brackets="awk '{print \"\\\"\"\$0\"\\\"\"}'"
alias ff.c='utils_find_c $@'
alias ff.cpp='utils_find_cpp $@'
alias ff.cxx='utils_find_cxx $@'
alias ff.java='utils_find_java $@'
alias ff.mk='utils_find_mk $@'
alias ff.sh='utils_find_sh $@'
alias ff.tar='utils_find_tar $@'
alias ff.f='utils_find_file $@'
alias ff.g.cxx='utils_find_grep_common cxx $@'
alias ff.g.java='utils_find_grep_common java $@'
alias ff.g.f='utils_find_grep_common file $@'
alias ff.g.mk='utils_find_grep_common mk $@'
alias ff.g.tar='utils_find_grep_common tar $@'
alias ff.g.sh='utils_find_grep_common sh $@'
alias vv='env DISPLAY="" vim -p'
alias nn='env DISPLAY="" nvim -p'
alias vvc='env DISPLAY="" vim -p -c "e ++enc=GB18030"'
alias vvp='env DISPLAY="" C_INCLUDE_PATH=${C_INCLUDE_PATH} CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH} vim -p'
alias a2='echo "aria2c --conf-path=$HOME/.config/aria2/aria2.conf" && aria2c --conf-path=$HOME/.config/aria2/aria2.conf'
if [[ ${SYSTEM_TYPE}"" == "mac" ]]; then
	ls --color >/dev/null 2>/dev/null
	if [[ $? == 0 ]]; then
		alias ls='ls --color'
	else
		alias ls='ls -G'
	fi
fi

alias lls='ls -l --time-style=+%Y-%m-%d_%H:%M:%S'
alias llsc='ls -l --time-style=+%Y-%m-%d_%H:%M:%S --quoting-style=locale'

# alias lsdu="du -sBM *|awk -F : '{printf(\"%08dM %s\n\", \$1, \$0)}'|sort | cut -f 2- -d M"
lsdu ()
{
	local lsdu_check_path=""
	local lsdu_param=""
	local lsdu_ret=0

	while getopts "kKmMrh" arg
	do
		case $arg in
			k | K)
				lsdu_param=K
				;;
			m | M)
				lsdu_param=M
				;;
			r )
				lsdu_param=M
				lsdu_ext_param=h
				;;
			h )
				echo "lsdu -m /path/*"
				echo "args: [k|K|m|M|r]"
				return 0;
				;;
			? )
				lsdu_param=M
				lsdu_ext_param=h
				;;
		esac
	done

	if [[ "$1" == "" ]]; then
		lsdu_check_path="*"
	elif [[ "$1" == "" ]]; then
		lsdu_check_path="*"
	else
		lsdu_check_path="$*"
	fi

	if [[ $lsdu_param == "K" ]]; then
		eval du -sBK "${lsdu_check_path}" |awk -F : '{printf("%08dM %s\n", $1, $0)}' |sort |cut -f 2- -d M
		lsdu_ret=$?
	elif [[ "${lsdu_ext_param}" == "h" ]]; then
		# eval du -sBM ${lsdu_check_path} |awk -F : '{printf("%08dM %s\n", $1, $0)}' |sort |cut -f 2- -d M |awk '{print $2 $3 $4 $5 $6 $7 $8 $9}'|xargs du -sh
		eval du -sBM "${lsdu_check_path}" |awk -F : '{printf("%08dM %s\n", $1, $0)}' |sort |cut -f 2- -d M |awk '{printf("%08dM %s\n", $1, $0)}'|xargs du -sh
		lsdu_ret=$?
	else
		eval du -sBM "${lsdu_check_path}" |awk -F : '{printf("%08dM %s\n", $1, $0)}' |sort |cut -f 2- -d M
		lsdu_ret=$?
	fi

	return $?
}	# ----------  end of function lsdu  ----------

####################################################################

export PATH
export TERM
export ENABLE_TRUE_COLOR

export DEVKITA64="$PATH_TOOLCHAIN_GCC_BASE/devkitA64"
export DEVKITPPC="$PATH_TOOLCHAIN_GCC_BASE/devkitPPC"
export DEVKITARM="$PATH_TOOLCHAIN_GCC_BASE/devkitARM"

export JAVA_HOME
export JRE_HOME
export CLASSPATH
export LD_LIBRARY_PATH
export PKG_CONFIG_PATH
# export LC_ALL=C
# export LANG="en_US.UTF-8"
export LANG="zh_CN.UTF-8"
# export LANG="zh_CN.GBK"
# export LANG="en_US.UTF-8"
# export LANG='C'
if [[ ${USE_SIMPLE_COLOR}"" == "true" ]]; then
	export LANG="en_US.UTF-8"
fi
# unset CLASSPATH
# unset JAVA_HOME
export VISUAL=vim
export EDITOR="$VISUAL"
export LLVMROOT
export LLVMBIN
export ANT_HOME
export PSH_LEFT=true
export NAME_COLOR_SSH=true

# # wine
# WINEARCH=win32

#### WARNING
#### Can not set this
#### because makefile will use local include instead of /usr/include
# export C_INCLUDE_PATH
# export CPLUS_INCLUDE_PATH


