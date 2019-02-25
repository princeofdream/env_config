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

USE_EXTERN_LD_PATH_ENV=true
USE_EXTERN_LD_PATH_USR_ENV=true
USE_EXTERN_PKG_PATH_ENV=true
USE_EXTERN_PKG_PATH_USR_ENV=true

############# !!!! ###############
USE_SYSTEM_LD_PKG_CONFIG_FIRST=false


############ Basic PATH variable #############
PATH_TOOLCHAIN_BASE=$HOME/Environment/toolchain
PATH_TOOLCHAIN_GCC_BASE=$PATH_TOOLCHAIN_BASE/gcc
PATH_TOOLCHAIN_JDK_BASE=$PATH_TOOLCHAIN_BASE/jdk

PATH_WEB_BASE=$HOME/Environment/web_base

PATH_ENV_ROOTFS_BASE=$HOME/Environment/env_rootfs

############# #Select  Terminal Color support ##################
# Select --> tmux / tmux-xterm / tmux-screen / tmux-st / none
ENABLE_TRUE_COLOR="tmux-screen"
# ENABLE_TRUE_COLOR="screen256"
# ENABLE_TRUE_COLOR="false"

SYSTEM_NAME=`uname -a`
SYSTEM_TYPE="linux"

if [[ $SYSTEM_NAME == "MSYS"* ]]; then
	SYSTEM_TYPE="msys"
elif [[ $SYSTEM_NAME == "MINGW"* ]]; then
	SYSTEM_TYPE="mingw"
elif [[ $SYSTEM_NAME == *"Microsoft"*"Linux"* ]]; then
	SYSTEM_TYPE="ms-linux"
elif [[ $SYSTEM_NAME == *"Darwin"* ]]; then
	SYSTEM_TYPE="mac"
fi

if [[ $SYSTEM_TYPE == "linux" ]]; then
	if [[ $DISPLAY == "" && $SSH_CONNECTION == "" ]]; then
			USE_SIMPLE_COLOR=true
	fi
elif [[ $SYSTEM_TYPE == "mac" ]]; then
	USE_SIMPLE_COLOR=false
else
	if [[ $SYSTEM_TYPE == "msys" || $SYSTEM_TYPE == "mingw" || $SYSTEM_TYPE == "ms-linux" ]]; then
		USE_SIMPLE_COLOR=false
	fi
fi

if [[ $USE_SIMPLE_COLOR == "true" ]]; then
	ENABLE_POWERLINE="none"
	ENABLE_TRUE_COLOR="false"
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
	if [[ ! $ORIGIN_PATH =~ $add_path ]]; then
		if [[ $PATH != "" ]]; then
			PATH+=":"
		fi
		PATH+="$add_path"
	fi
}	# ----------  end of function append_path_env  ----------

####################################################################

ORIGIN_PATH=$PATH
PATH=""

if [[ $SYSTEM_TYPE == "mac" ]]; then
	PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

############# #Jave Environment ##################
if [[ "$USE_EXTERN_JAVA_ENV" == "true" ]]; then
	# JAVA_HOME="/usr/lib/jvm/default-java"
	JAVA_HOME="$PATH_TOOLCHAIN_JDK_BASE/default-java"
	JRE_HOME=$JAVA_HOME/jre
	if [[ $CLASSPATH"x" == "x" ]]; then
		TMP_CLASSPATH=""
	else
		TMP_CLASSPATH=":$CLASSPATH"
	fi
	CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$PATH_ENV_ROOTFS_BASE/lib
	CLASSPATH+=$TMP_CLASSPATH
	append_path_env "$JAVA_HOME/bin:$JAVA_HOME/jre/bin"
fi

############# #ant Environment ##################
if [[ "$USE_EXTERN_ANT_ENV" == "true" ]]; then
	# ANT_HOME="$PATH_ENV_ROOTFS_BASE"
	ANT_HOME="$PATH_TOOLCHAIN_JDK_BASE/apache-ant"
	append_path_env "$ANT_HOME/bin"
fi

############# #mvn Environment ##################
if [[ "$USE_EXTERN_MAVEN_ENV" == "true" ]]; then
	# M2_HOME="$PATH_ENV_ROOTFS_BASE"
	M2_HOME="$PATH_TOOLCHAIN_JDK_BASE/apache-maven"
	append_path_env "$M2_HOME/bin"
fi

############# #tomcat Environment ##################
if [[ "$USE_EXTERN_TOMCAT_ENV" == "true" ]]; then
	CATALINA_HOME="$PATH_WEB_BASE/tomcat/bin"
	CATALINA_BASE="$PATH_WEB_BASE/tomcat"
	CATALINA_PID="$CATALINA_BASE/tomcat.pid"
fi

############# #tomcat Environment ##################
if [[ "$USE_EXTERN_OPENGROK_ENV" == "true" ]]; then
	export OPENGROK_TOMCAT_BASE=$CATALINA_BASE
	export OPENGROK_APP_SERVER=Tomcat
	export OPENGROK_INSTANCE_BASE=$PATH_WEB_BASE/opengrok
fi


LLVM_ARM_ROOT=$PATH_TOOLCHAIN_GCC_BASE/snapdragon-llvm
LLVM_ORIGIN_ROOT=$PATH_ENV_ROOTFS_BASE
LLVMROOT=$LLVM_ARM_ROOT
LLVMBIN=$LLVMROOT/bin

if [[ "$USE_LLVM_FOR_ARM" == "true" ]]; then
	##### llvm runtime #####
	append_path_env "$LLVM_ARM_ROOT/bin"
fi


############# #Web_Base Environment ##################
if [[ "$USE_EXTERN_WEB_BASE_ENV" == "true" ]]; then
	##### web_base runtime #####
	append_path_env "$PATH_WEB_BASE/bin"
	append_path_env "$PATH_WEB_BASE/sbin"
	append_path_env "$PATH_WEB_BASE/man"
fi

############# #Fake rootfs Environment ##################
if [[ "$USE_EXTERN_ROOTFS_ENV" == "true" ]]; then
	##### env_rootfs runtime #####
	append_path_env "$PATH_ENV_ROOTFS_BASE/bin"
	append_path_env "$PATH_ENV_ROOTFS_BASE/sbin"
	append_path_env "$PATH_ENV_ROOTFS_BASE/man"
fi

############# #Fake rootfs usr Environment ##################
if [[ "$USE_EXTERN_ROOTFS_USR_ENV" == "true" ]]; then
	append_path_env "$PATH_ENV_ROOTFS_BASE/usr/bin"
	append_path_env "$PATH_ENV_ROOTFS_BASE/usr/sbin"
	append_path_env "$PATH_ENV_ROOTFS_BASE/usr/man"
fi

############# #Fake rootfs usr local Environment ##################
if [[ "$USE_EXTERN_ROOTFS_USR_LOCAL_ENV" == "true" ]]; then
	append_path_env "$PATH_ENV_ROOTFS_BASE/usr/local/bin"
	append_path_env "$PATH_ENV_ROOTFS_BASE/usr/local/sbin"
	append_path_env "$PATH_ENV_ROOTFS_BASE/usr/local/man"
fi

############# #Origin PATH Environment ##################
if [[ $PATH != "" ]]; then
	PATH+=":"
fi
PATH+="$ORIGIN_PATH"

############# #Extern toolchain Environment ##################
if [[ "$USE_EXTERN_TOOLCHAIN_ENV" == "true" ]]; then
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/toolchain-openwrt-arm/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/toolchain-openwrt-aarch64/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/arm-linux-androideabi/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-arm-eabi/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-arm-linux-gnueabi/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-arm-linux-gnueabihf/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-aarch64-linux-gnu/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/gcc-linaro-aarch64-none-elf/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/devkitA64/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/devkitPPC/bin"
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/devkitARM/bin"
fi

############# #Extern Android Environment ##################
if [[ "$USE_EXTERN_ANDROID_ENV" == "true" ]]; then
	append_path_env "$PATH_TOOLCHAIN_GCC_BASE/arm-2010q1/bin"
	append_path_env "$HOME/Environment/Android/Sdk/platform-tools"
	append_path_env "$HOME/Environment/Android/android-ndk"
fi

############# #Terminal Color Support ##################
if [[ "$ENABLE_TRUE_COLOR" == "tmux-xterm" ]]; then
	alias tmux="env TERM=xterm-256color tmux"
	# TERM="xterm-256color"
	TERM="screen-256color"
elif [[ "$ENABLE_TRUE_COLOR" == "tmux-screen" ]]; then
	TERM="screen-256color"
elif [[ "$ENABLE_TRUE_COLOR" == "tmux-st" ]]; then
	TERM="st-256color"
elif [[ "$ENABLE_TRUE_COLOR" == "screen256" ]]; then
	TERM="screen-256color"
elif [[ "$ENABLE_TRUE_COLOR" == "false" ]]; then
	TERM="xterm"
else
	TERM="screen-256color"
fi


############# #LD_LIBRARY_PATH Environment ##################
if [[ "$LD_LIBRARY_PATH" == "" || $LD_LIBRARY_PATH == "/home"* ]]; then
	SYSTEM_LD_LIBRARY_PATH="/lib:/lib64:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64"
else
	SYSTEM_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
fi
if [[ "$USE_EXTERN_LD_PATH_ENV" == "true" ]]; then
	EXTERN_LD_LIBRARY_PATH="$PATH_ENV_ROOTFS_BASE/lib"
	EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/lib64"
fi
if [[ "$USE_EXTERN_LD_PATH_USR_ENV" == "true" ]]; then
	if [[ "$EXTERN_LD_LIBRARY_PATH" == "" ]]; then
		EXTERN_LD_LIBRARY_PATH="$PATH_ENV_ROOTFS_BASE/usr/lib"
	else
		EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib"
	fi
	EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib"
	EXTERN_LD_LIBRARY_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib64"
fi

## Set LD_LIBRARY_PATH
LD_LIBRARY_PATH_SYSTEM_FIRST="$SYSTEM_LD_LIBRARY_PATH"
LD_LIBRARY_PATH_CUSTOM_FIRST="$SYSTEM_LD_LIBRARY_PATH"
if [[ ! "$EXTERN_LD_LIBRARY_PATH" == "" ]]; then
	LD_LIBRARY_PATH_SYSTEM_FIRST+=":$EXTERN_LD_LIBRARY_PATH"
	LD_LIBRARY_PATH_CUSTOM_FIRST="$EXTERN_LD_LIBRARY_PATH:$LD_LIBRARY_PATH_CUSTOM_FIRST"
fi

if [[ "$USE_SYSTEM_LD_PKG_CONFIG_FIRST" == "true" ]]; then
	LD_LIBRARY_PATH="$LD_LIBRARY_PATH_SYSTEM_FIRST"
else
	LD_LIBRARY_PATH="$LD_LIBRARY_PATH_CUSTOM_FIRST"
fi

############# #PKG_CONFIG_PATH Environment ##################
if [[ "$PKG_CONFIG_PATH" == "" || $PKG_CONFIG_PATH == "/home"* ]]; then
	SYSTEM_PKG_CONFIG_PATH="/lib:/lib64:/usr/lib:/usr/lib64"
else
	SYSTEM_PKG_CONFIG_PATH=$PKG_CONFIG_PATH
fi
if [[ "$USE_EXTERN_PKG_PATH_ENV" == "true" ]]; then
	EXTERN_PKG_CONFIG_PATH="$PATH_ENV_ROOTFS_BASE/lib"
	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/lib64"
fi
if [[ "$USE_EXTERN_PKG_PATH_USR_ENV" == "true" ]]; then
	if [[ "$EXTERN_PKG_CONFIG_PATH" == "" ]]; then
		EXTERN_PKG_CONFIG_PATH="$PATH_ENV_ROOTFS_BASE/usr/lib"
	else
		EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib"
	fi
	EXTERN_PKG_CONFIG_PATH+=":$PATH_ENV_ROOTFS_BASE/usr/lib64"
fi

## Set PKG_CONFIG_PATH
PKG_CONFIG_PATH_SYSTEM_FIRST="$SYSTEM_PKG_CONFIG_PATH"
PKG_CONFIG_PATH_CUSTOM_FIRST="$SYSTEM_PKG_CONFIG_PATH"
if [[ ! "$EXTERN_PKG_CONFIG_PATH" == "" ]]; then
	PKG_CONFIG_PATH_SYSTEM_FIRST+=":$EXTERN_PKG_CONFIG_PATH"
	PKG_CONFIG_PATH_CUSTOM_FIRST="$EXTERN_PKG_CONFIG_PATH:$PKG_CONFIG_PATH_CUSTOM_FIRST"
fi
if [[ "$USE_SYSTEM_LD_PKG_CONFIG_FIRST" == "true" ]]; then
	PKG_CONFIG_PATH="$PKG_CONFIG_PATH_SYSTEM_FIRST"
else
	PKG_CONFIG_PATH="$PKG_CONFIG_PATH_CUSTOM_FIRST"
fi

ORIGIN_PATH=$PATH
SNAPDRAGON_PATH=$PATH_TOOLCHAIN_GCC_BASE/snapdragon-llvm/bin:$PATH

############# #sudo Environment ##################
alias sudo='sudo env PATH=$PATH LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SYSTEM_FIRST PKG_CONFIG_PATH=$PKG_CONFIG_PATH_SYSTEM_FIRST'
alias yum='env LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SYSTEM_FIRST PKG_CONFIG_PATH=$PKG_CONFIG_PATH_SYSTEM_FIRST yum'

alias rq='PROMPT_COMMAND="_update_ps1"'
alias s_openjdk_8='switch_java_sdk "openjdk" "8"'
alias s_openjdk_9='switch_java_sdk "openjdk" "9"'
alias s_jdk_6='switch_java_sdk "jdk" "6"'

alias s_path_origin='export PATH=$ORIGIN_PATH'
alias s_path_snapdragon='export PATH=$SNAPDRAGON_PATH && export LLVMROOT=$LLVM_ARM_ROOT && export LLVMBIN=$LLVMROOT/bin'

alias ncdu='ncdu --color dark -rr -x --exclude .git --exclude node_modules'

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
export LANG="en_US.UTF-8"
# export LANG="zh_CN.GBK"
# export LANG="en_US.UTF-8"
# export LANG='C'
# unset CLASSPATH
# unset JAVA_HOME
export VISUAL=vim
export EDITOR="$VISUAL"
export LLVMROOT
export LLVMBIN
export ANT_HOME


