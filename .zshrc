# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/$WHOAMI/.zshrc'

autoload -Uz compinit
compinit

# powerline and powerline-shell
ENABLE_POWERLINE="powerline"

if [ "$ENABLE_POWERLINE" = "powerline" ]
then
	powerline-daemon -q
	. $HOME/.vim/bundle/powerline/powerline/bindings/zsh/powerline.zsh
else

	if [ "$ENABLE_POWERLINE" = "powerline-shell" ]
	then
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
fi

# # End of lines added by compinstall
