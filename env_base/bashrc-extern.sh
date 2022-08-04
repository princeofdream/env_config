#===============================================================================
#
#          FILE: bash_extern_rc.sh
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



############# #Select powerline ##################
# Select --> powerline / powerline-shell / none
# ENABLE_POWERLINE="powerline-shell"
ENABLE_POWERLINE="powerline-sh"
# ENABLE_POWERLINE="powerline-none"

if [[ -f $HOME/.common.sh ]]; then
	source $HOME/.common.sh
fi

common_PS1_env_setup ()
{
	GIT_PS1_STAT=`__git_ps1 "%s" >/dev/null 2>/dev/null`
	git_ps_ret=$?

	if [[ "$SYSTEM_TYPE" == "msys" || "$SYSTEM_TYPE" == "mingw"* ]]; then
		PS1='\u@\h:\[\033[01;36m\]\w\[\033[00m\] \$\[\033[01;32m\] \[\033[00m\]\n'
	elif [[ $USE_SIMPLE_COLOR == "true" ]]; then
		if [[ $git_ps_ret == 0 ]]; then
			PS1='\u@\h:\[\033[01;36m\]\w\[\033[00m\] \$\[\033[01;32m\] \[\033[00m\]\n'
		else
			PS1='\u@\h:\[\033[01;36m\]\w\[\033[00m\] \$\[\033[01;32m\] \[\033[00m\]\n'
			# PS1='\u@\h:\[\033[01;36m\]\w\[\033[00m\] \$\[\033[01;32m\]$(__git_ps1 " (%s)") \[\033[00m\]\n'
		fi
	else
		# PS1='\u@\h:\[\033[01;36m\]\w\[\033[00m\] $\[\033[01;32m\]$(__git_ps1 " (%s)") \[\033[00m\]\n'
#         PS1='\[\e[38;5;15m\]\[\e[48;5;31m\] \u \
# \[\e[48;5;236m\]\[\e[38;5;031m\] \[\e[38;5;251m\]\[\e[48;5;236m\] \w \
# \[\e[48;5;117m\]\[\e[38;5;236m\] \[\e[38;5;234m\]\[\e[48;5;117m\]\$ \
# \[\e[48;5;236m\]\[\e[38;5;117m\] \[\e[38;5;140m\]\[\e[48;5;236m\]\j\
# $(__git_ps1 "\[\e[48;5;236m\]\[\e[38;5;244m\] \[\e[38;5;120m\]\[\e[48;5;236m\] (%s)") \
# \[\e[48;5;0m\]\[\e[38;5;236m\]\[\e[0m\]\[\e[0m\]\n'
		if [[ ${git_ps_ret} == 0 ]]; then
			PS1='\[\e[38;5;254m\]\[\e[48;5;31m\] \u \[\e[38;5;31m\]\[\e[48;5;237m\]\[\e[38;5;254m\]\[\e[48;5;237m\] \
\w \[\e[38;5;237m\]\[\e[48;5;245m\]\[\e[38;5;232m\]\[\e[48;5;245m\] \
\$ \[\e[38;5;245m\]\[\e[48;5;238m\]\[\e[38;5;39m\]\[\e[48;5;238m\] \
\j \[\e[38;5;238m\]\[\e[48;5;148m\]\[\e[38;5;0m\]\[\e[48;5;148m\] \
$(__git_ps1 " (%s)") \[\e[0m\]\[\e[38;5;148m\]\[\e[0m\]\[\e[0m\]
\[\e[0m\]\[\e[0m\]\[\e[0m\]'
		else
			PS1='\[\e[38;5;254m\]\[\e[48;5;31m\] \u \[\e[38;5;31m\]\[\e[48;5;237m\]\[\e[38;5;254m\]\[\e[48;5;237m\] \
\w \[\e[38;5;237m\]\[\e[48;5;245m\]\[\e[38;5;232m\]\[\e[48;5;245m\] \
\$ \[\e[38;5;245m\]\[\e[48;5;238m\]\[\e[38;5;39m\]\[\e[48;5;238m\] \
\j \[\e[38;5;238m\]\[\e[48;5;148m\]\[\e[38;5;0m\]\[\e[48;5;148m\] \
\[\e[0m\]\[\e[38;5;148m\]\[\e[0m\]\[\e[0m\]
\[\e[0m\]\[\e[0m\]\[\e[0m\]'
		fi
	fi
}	# ----------  end of function common_PS1_env_setup  ----------
# \[\e[48;5;236m\]\[\e[38;5;226m\] $(__git_ps1 "\[\e[38;5;46m\]\[\e[48;5;236m\](%s)") \[\033[00m\]\[\e[0m\]\
# \[\e[38;5;236m\]\[\e[0m\]\[\e[0m\]\n'
# \[\033[01;163m\]$(__git_ps1 " (%s)") \[\033[00m\]\[\e[0m\]\

tmux_PS1_env_setup ()
{
	############# #Tmux Environment ##################
	if [[ -n $TMUX ]]; then
		if [[ ! -z $TMUX ]]; then
			ret=`tmux -V 2>/dev/null`
			if [[ $ret == 0 ]]; then
				PS1="$PS1"'$(tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
			fi
		fi
	fi
}	# ----------  end of function tmux_PS1_env_setup  ----------

############# #Extern PS1 Setup ##################
common_PS1_env_setup
tmux_PS1_env_setup

############# #Powerline Environment ##################
if [[ ${ENABLE_POWERLINE}"" == "powerline" ]]; then
	## powerline for bash
	powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1

	if [ -f "$HOME/.exvim/bundle/powerline/powerline/bindings/bash/powerline.sh" ]; then
		. $HOME/.exvim/bundle/powerline/powerline/bindings/bash/powerline.sh
	fi
elif [[ ${ENABLE_POWERLINE}"" == "powerline-shell" ]]; then
	CHECK_CMD_STAT=`powerline-shell 2>/dev/null`
	CMD_STAT=$?
	if [[ ${CMD_STAT} == 0 ]]; then
		function _update_ps1() {
			# CHECK_CMD_STAT=`powerline-shell 2>/dev/null`
			# CMD_STAT=$?
			# if [[ $CMD_STAT == 0 ]]; then
				PS1=$(powerline-shell $?)
				# PS1=$(/home/james/env/my_c_program/powerline-sh/powerline-sh)
			# else
				# common_PS1_env_setup
				# tmux_PS1_env_setup
			# fi
		}
		if [[ ${TERM}"" != "linux" && ! ${PROMPT_COMMAND}"" =~ "_update_ps1" ]]; then
			PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
		fi
	fi
elif [[ ${ENABLE_POWERLINE}"" == "powerline-sh" ]]; then
	CHECK_CMD_STAT=`powerline-sh 2>/dev/null`
	CMD_STAT=$?
	if [[ ${CMD_STAT} == 0 ]]; then
		function _update_ps1() {
			PS1=$(powerline-sh $?)
		}
		if [[ ${TERM}"" != "linux" && ! ${PROMPT_COMMAND}"" =~ "_update_ps1" ]]; then
			PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
		fi
	else
		if [[ ${SYSTEM_TYPE}"" == "mingw32" ]]; then
			CHECK_CMD_STAT=`powerline-sh32 2>/dev/null`
			CMD_STAT=$?
			if [[ $CMD_STAT == 0 ]]; then
				function _update_ps1() {
					PS1=$(powerline-sh32 $?)
				}
				if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
					PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
				fi
			fi
		fi
	fi
fi

export BASH_VERSION=$(help |grep -n [0-9]|grep bash)



