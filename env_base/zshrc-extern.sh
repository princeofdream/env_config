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


# # Lines configured by zsh-newuser-install
# HISTFILE=~/.histfile
# HISTSIZE=5000
# SAVEHIST=5000
# bindkey -v
# # End of lines configured by zsh-newuser-install
# # The following lines were added by compinstall
# zstyle :compinstall filename '$HOME/.zshrc'

# autoload -Uz compinit
# compinit

# # End of lines added by compinstall


if [[ -f $HOME/.common.sh ]]; then
	source ~/.common.sh
fi

# powerline and powerline-shell powerline-sh
# ENABLE_POWERLINE="powerline"
# ENABLE_POWERLINE="powerline-shell"
ENABLE_POWERLINE="powerline-sh----"

if [[ "$ENABLE_POWERLINE" = "powerline" ]]; then
	powerline-daemon -q
	. $HOME/.vim/bundle/powerline/powerline/bindings/zsh/powerline.zsh
elif [[ "$ENABLE_POWERLINE" = "powerline-sh" ]]; then
	# powerline-shell for zsh
	function powerline_precmd() {
		PS1="$(powerline-sh $? 2> /dev/null)"
	}

	function install_powerline_precmd() {
		for s in "${precmd_functions[@]}"; do
			if [ "$s" = "powerline_precmd" ]; then
				return
			fi
		done
		precmd_functions+=(powerline_precmd)
	}
elif [[ "$ENABLE_POWERLINE" = "powerline-shell" ]]; then
	# powerline-shell for zsh
	function powerline_precmd() {
		PS1="$($HOME/.vim/bundle/powerline-shell/powerline-shell.py $? --shell zsh 2> /dev/null)"
	}

	function install_powerline_precmd() {
		for s in "${precmd_functions[@]}"; do
			if [ "$s" = "powerline_precmd" ]; then
				return
			fi
		done
		precmd_functions+=(powerline_precmd)
	}

	if [ "$TERM" != "linux" ]; then
		install_powerline_precmd
	fi
fi

