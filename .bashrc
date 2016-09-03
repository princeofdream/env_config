# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
#alias la='ls -A'
alias l='ls -CF'

alias sudo='sudo env PATH=$PATH'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi






############# #By James ##################

JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
#JAVA_HOME="$HOME/Enviroment/toolchain/jdk1.8.0_73"
#JAVA_HOME="$HOME/Enviroment/toolchain/jdk1.7.0_80"
#JAVA_HOME="$HOME/Enviroment/toolchain/jdk1.6.0_45"
JRE_HOME=$JAVA_HOME/jre
CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH


PATH_TMP=$PATH

PATH+=":/sbin:/usr/sbin"

PATH+=":$HOME/Enviroment/env_rootfs/bin"
PATH+=":$HOME/Enviroment/env_rootfs/bin/etc"
PATH+=":$HOME/Enviroment/env_rootfs/bin/sbin"
PATH+=":$HOME/Enviroment/env_rootfs/bin/bin"
PATH+=":$HOME/Enviroment/env_rootfs/bin/man"

PATH+=":$HOME/Enviroment/tmp_rootfs/bin"
PATH+=":$HOME/Enviroment/tmp_rootfs/bin/etc"
PATH+=":$HOME/Enviroment/tmp_rootfs/bin/sbin"
PATH+=":$HOME/Enviroment/tmp_rootfs/bin/bin"
PATH+=":$HOME/Enviroment/tmp_rootfs/bin/man"

PATH+="$PATH_TMP"


PATH+=":$HOME/Enviroment/toolchain/toolchain-arm_cortex-a9+vfpv3_gcc-4.8-linaro_eglibc-2.19_eabi/bin"
PATH+=":$HOME/Enviroment/toolchain/arm-2009q1/bin"
PATH+=":$HOME/Enviroment/toolchain/arm-2009q3/bin"


PATH+=":$HOME/Enviroment/toolchain/arm-eabi-4.8/bin"
PATH+=":$HOME/Enviroment/toolchain/arm-linux-androideabi-4.8/bin"


PATH+=":$HOME/Enviroment/Android/Sdk/platform-tools"
PATH+=":$HOME/Enviroment/Android_Env/android-studio/bin"


##JAVA
PATH="$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH"

# s3c2451
# PATH+=":$HOME/share_projects/2451/opt/Embedsky/gcc-4.6.2-glibc-2.13-linaro-multilib-2011.12/tq-linaro-toolchain/bin"

if [ -f "/etc/bash_completion.d/git-prompt" ]
then
	source /etc/bash_completion.d/git-prompt
else
	if [ -f "/etc/bash_completion.d/git" ]
	then
		source /etc/bash_completion.d/git
		source /usr/share/git-core/contrib/completion/git-prompt.sh
	fi
fi
# PS1='\u@\h:\[\033[01;36m\]\w\[\033[00m\] $\[\033[01;32m\]$(__git_ps1) \[\033[00m\]\n'
PS1='\u@\h:\[\033[01;36m\]\w\[\033[00m\] $\[\033[01;32m\]$(__git_ps1 " (%s)") \[\033[00m\]\n'

if [ -n $TMUX ]
then
	if [ ! -z $TMUX ]
	then
		PS1="$PS1"'$(tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
	fi
fi







# powerline and powerline-shell
# ENABLE_POWERLINE="powerline-none"
# ENABLE_POWERLINE="powerline"
ENABLE_POWERLINE="powerline-shell"

if [ "$ENABLE_POWERLINE" = "powerline" ]
then
	## powerline for bash
	powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1
	. $HOME/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh
else
	if [ "$ENABLE_POWERLINE" = "powerline-shell" ]
	then
		function _update_ps1() {
			PS1="$($HOME/.vim/bundle/powerline-shell/powerline-shell.py $? 2> /dev/null)"
		}

		# powerline-shell for bash
		if [ -f "$HOME/.vim/bundle/powerline-shell/powerline-shell.py" ]
		then
			if [ "$TERM" != "linux" ]; then
				PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
			fi
		fi
	fi

fi


GIT_PS1_SHOWDIRTYSTATE=enabled
TERM="screen-256color"
TMUX_POWERLINE_SEG_WEATHER_LOCATION=2161838


#export PATH
export TERM
export TMUX_POWERLINE_SEG_WEATHER_LOCATION
export JAVA_HOME
export JRE_HOME
export CLASSPATH
export GIT_PS1_SHOWDIRTYSTATE



