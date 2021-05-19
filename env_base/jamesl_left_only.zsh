# oh-my-zsh jamesl Theme

# jamesl's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segments of the prompt, default order declaration

typeset -aHg JAMESL_PROMPT_LINE_ONE_SEGMENTS=(
	# prompt_context
	prompt_user
	# prompt_host
	prompt_ssh
	prompt_virtualenv
	prompt_dir
	prompt_pre_cmd_stat
	prompt_symbol
	prompt_status
	prompt_git
	prompt_android_env
	prompt_time
	prompt_end
)

typeset -aHg JAMESL_RPROMPT_LINE_ONE_SEGMENTS=(
	prompt_ssh
	prompt_git
	prompt_android_env
	# prompt_host
	prompt_time
	prompt_end
)

typeset -aHg JAMESL_PROMPT_LINE_TWO_SEGMENTS=(
	prompt_ssh
	prompt_git
	# prompt_host
	prompt_time
	prompt_end
)

typeset -aHg JAMESL_PROMPT_SEGMENTS=(
	prompt_empty
	prompt_end
)

typeset -aHg JAMESL_RPROMPT_SEGMENTS=(
	prompt_end
)
### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

PRE_CMD_RET=0
CURRENT_BG='NONE'
CURRENT_RBG='NONE'
if [[ -z "$PRIMARY_FG" ]]; then
	PRIMARY_FG=black
fi

# Characters
SEGMENT_SEPARATOR_LEFT="\ue0b0"
SEGMENT_SEPARATOR_RIGHT="\ue0b2"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
OK_SYMB="\u2714"
LIGHTNING="\u26a1"
GEAR="\u2699"
UP_SYMB="\u25b2"
DOWN_SYMB="\u25bC"
LINK_UP="\u25B2"
LINK_DOWN="\u25BC"
DIVERGED="\u25e9\u25ea"
STASHED="\u259f"

ZSH_THEME_GIT_PROMPT_PREFIX=" [38;5;177m${PLUSMINUS}[38;5;85m $BRANCH"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN="[38;5;40m$OK_SYMB"
ZSH_THEME_GIT_PROMPT_AHEAD="[38;5;45m$UP_SYMB "
ZSH_THEME_GIT_PROMPT_BEHIND="[38;5;199m$DOWN_SYMB "
ZSH_THEME_GIT_PROMPT_STAGED="[38;5;46m●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="[38;5;227m●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="[38;5;196m● "
ZSH_THEME_GIT_PROMPT_DIVERGED="[38;5;196m$DIVERGED "
ZSH_THEME_GIT_PROMPT_STASHED="[38;5;177m$STASHED "

ZSH_THEME_DISABLE_LINK_UP_DOWN="true"

color_transfer() {
	if [[ $1 == "green" ]]; then
		TRAN_COLOR=78
	elif [[ $1 == "blue" ]]; then
		TRAN_COLOR=75
	elif [[ $1 == "black" ]]; then
		TRAN_COLOR=232
	elif [[ $1 == "white" ]]; then
		TRAN_COLOR=254
	elif [[ $1 == "red" ]]; then
		TRAN_COLOR=200
	elif [[ $1 == "yellow" ]]; then
		TRAN_COLOR=227
	elif [[ $1 == "default" ]]; then
		TRAN_COLOR=254
	else
		TRAN_COLOR=$1
	fi
	echo "$TRAN_COLOR"
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.

prompt_segment_main() {
	local mode=$1
	if [[ "${mode}x" == "leftxx" ]]; then
		prompt_segment $2 $3 $4 $5 $6 $7 $8 $9
	else
		rprompt_segment $2 $3 $4 $5 $6 $7 $8 $9
	fi
}

prompt_segment() {
	local bg fg
	# [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	# [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
	local fg_color bg_color pre_bg_color
	fg_color=`color_transfer white`
	bg_color=`color_transfer black`
	pre_bg_color=`color_transfer $CURRENT_BG`

	if [[ -n $1 ]]; then
		fg_color=`color_transfer $2`
	fi

	if [[ -n $2 ]]; then
		bg_color=`color_transfer $1`
	fi

	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
		print -n "[48;5;${bg_color}m[38;5;${pre_bg_color}m${SEGMENT_SEPARATOR_LEFT}[48;5;${bg_color}m[38;5;${fg_color}m"
	else
		if [[ "${ZSH_THEME_DISABLE_LINK_UP_DOWN}x" == "truex" ]]; then
			print -n "[48;5;${bg_color}m[38;5;${fg_color}m"
		else
			LINE_ONE_LEFT_LINK_UP=`print $LINK_UP`
			print -n "[48;5;${bg_color}m[38;5;${fg_color}m$LINE_ONE_LEFT_LINK_UP"
		fi
	fi

	## update pre bg to current bg
	CURRENT_BG=$1
	[[ -n $3 ]] && print -n $3
}

rprompt_segment() {
	local bg fg
	local fg_color bg_color pre_bg_color
	fg_color=`color_transfer white`
	bg_color=`color_transfer black`
	pre_bg_color=`color_transfer $CURRENT_BG`

	if [[ -n $1 ]]; then
		fg_color=`color_transfer $2`
	fi

	if [[ -n $2 ]]; then
		bg_color=`color_transfer $1`
	fi

	if [[ $CURRENT_RBG != 'NONE' && $1 != $CURRENT_BG ]]; then
		# print -n "[48;5;${bg_color}m[38;5;${pre_bg_color}m${SEGMENT_SEPARATOR_RIGHT}[48;5;${bg_color}m[38;5;${fg_color}m"
		print -n "[38;5;${bg_color}m${SEGMENT_SEPARATOR_RIGHT}[48;5;${bg_color}m[38;5;${fg_color}m"
	else
		print -n "[38;5;${bg_color}m${SEGMENT_SEPARATOR_RIGHT}[48;5;${bg_color}m[38;5;${fg_color}m"
	fi
	[[ -n $3 ]] && print -n $3

	## update pre bg to current bg
	CURRENT_BG=$1
}

# End the prompt, closing any open segments
prompt_end() {
	local mode=$1
	local pre_bg_color
	pre_bg_color=`color_transfer $CURRENT_BG`

	if [[ -n $CURRENT_BG ]]; then
		if [[ "${mode}x" == "leftx" ]]; then
			print -n "[0m[38;5;${pre_bg_color}m${SEGMENT_SEPARATOR_LEFT}[0m[0m[0m[0m[0m[0m[0m[0m"
		else
			print -n "[0m[38;5;${pre_bg_color}m[0m[0m[0m[0m[0m[0m[0m[0m"
		fi
	else
		print -n "%{%k%}"
	fi
	# print -n "%{%f%}"
	CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
	local mode=$1
	local user=`whoami`

	if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
		prompt_segment_main "${mode}x" $PRIMARY_FG default " %(!.%{%F{yellow}%}.)$user@%m "
	fi
}

# Git: branch/detached head, dirty status
prompt_git() {
	local color ref
	local mode=$1

	is_dirty() {
		test -n "$(git status --porcelain -uno --ignore-submodules)"
	}
	ref="$vcs_info_msg_0_"
	if [[ -n "$ref" ]]; then
		# if is_dirty; then
		#     color=237
		#     ref="${ref} $PLUSMINUS"
		# else
			color=237
			ref="${ref} "
		# fi
		if [[ "${ref/.../}" == "$ref" ]]; then
			ref="$BRANCH $ref"
		else
			ref="$DETACHED ${ref/.../}"
		fi
		# prompt_segment_main "${mode}x" $color $PRIMARY_FG
		# print -n " $ref"
		# prompt_segment_main "${mode}x" $color $PRIMARY_FG "$(jamesl_git_prompt)"
		prompt_segment_main "${mode}x" $color 85 " ${BRANCH}$(jamesl_git_branch) "
	fi
}

# Dir: current working directory
prompt_dir() {
	local mode=$1
	local fg_color=253
	local bg_color=237

	prompt_segment_main "${mode}x" $bg_color $fg_color ' %~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
	local mode=$1
	local symbols
	local fg_color=blue
	local bg_color=237

	symbols=()
	jobs_count=$(jobs -l | wc -l)
	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
	[[ jobs_count -gt 0 ]] && symbols+="%{%F{cyan}%}${GEAR}%{%F{blue}%}${jobs_count}"

	[[ -n "$symbols" ]] && prompt_segment_main "${mode}x" $bg_color $fg_color " $symbols "
}

# Display current virtual environment
prompt_virtualenv() {
	local mode=$1
	if [[ -n $VIRTUAL_ENV ]]; then
		color=cyan
		prompt_segment_main "${mode}x" $color $PRIMARY_FG
		print -Pn " $(basename $VIRTUAL_ENV) "
	fi
}

prompt_user() {
	local mode=$1
	local user=`whoami`

	if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
		prompt_segment_main "${mode}x" 31 252 " $user "
	fi
}

prompt_host() {
	local mode=$1
	local fg_color=252
	local bg_color=31

	prompt_segment_main "${mode}x" $bg_color $fg_color " %m "
}

prompt_android_env() {
	local mode=$1
	local fg_color=235
	local bg_color=181

	if [[ -n $TARGET_PRODUCT ]]; then
		prompt_segment_main "${mode}x" $bg_color $fg_color " ${TARGET_PRODUCT}-${TARGET_BUILD_VARIANT} "
	fi
}

prompt_time() {
	local mode=$1
	local fg_color=239
	local bg_color=111

	prompt_segment_main "${mode}x" $bg_color $fg_color " $(date +%H:%M:%S) "
}

prompt_ssh() {
	local mode=$1
	local fg_color=252
	local bg_color=166

	if [[ -n "$SSH_CONNECTION" ]]; then
		prompt_segment_main "${mode}x" $bg_color $fg_color " ⌁ "
	fi
}

prompt_empty() {
	prompt_segment 249 249 " "
}


prompt_symbol() {
	local mode=$1
	local symbol="$"
	local sym_fg_color=232
	local sym_bg_color=247

	if [[ $UID -eq 0 ]]; then
		symbol="#"
	fi

	# if [[ $PRE_CMD_RET != 0 ]]; then
	#     sym_fg_color=253
	#     sym_bg_color=161
	# fi
	prompt_segment_main "${mode}x" $sym_bg_color $sym_fg_color " $symbol "
}


prompt_pre_cmd_stat() {
	local sym_fg_color=232
	local sym_bg_color=247

	if [[ $PRE_CMD_RET != 0 ]]; then
		sym_fg_color=254
		sym_bg_color=204
		prompt_segment $sym_bg_color $sym_fg_color " ${CROSS}[1m${PRE_CMD_RET} "
	fi
}

## Main prompt
prompt_jamesl_line_one() {
	RETVAL=$?
	CURRENT_BG='NONE'
	local mode=$1

	if [[ "${mode}x" == "leftx" ]]; then
		for prompt_segment in "${JAMESL_PROMPT_LINE_ONE_SEGMENTS[@]}"; do
			[[ -n $prompt_segment ]] && $prompt_segment $@
		done
	else
		for prompt_segment in "${JAMESL_RPROMPT_LINE_ONE_SEGMENTS[@]}"; do
			[[ -n $prompt_segment ]] && $prompt_segment $@
		done
	fi
}

prompt_jamesl_line_two() {
	RETVAL=$?
	CURRENT_RBG='NONE'
	for prompt_segment in "${JAMESL_PROMPT_LINE_TWO_SEGMENTS[@]}"; do
		[[ -n $prompt_segment ]] && $prompt_segment $@
	done
}



#################################################################################
#################################################################################



### NVM

ZSH_THEME_NVM_PROMPT_PREFIX="%B⬡%b "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

jamesl_git_branch () {
	ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
	ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
	echo "${ref#refs/heads/}"
}

jamesl_git_status() {
	_STATUS=""

# check status of local repository
	_INDEX=$(command git status --porcelain -b 2> /dev/null)
	if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then
		_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
	fi
	if $(echo "$_INDEX" | command grep -q '^## .*behind'); then
		_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
	fi
	if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then
		_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
	fi

# check status of files
	# _INDEX=$(command git status --porcelain 2> /dev/null)
	if [[ -n "$_INDEX" ]]; then
		if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
			_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
		fi
		if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
			_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
		fi
		if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
			_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
		fi
		if $(echo "$_INDEX" | command grep -q '^UU '); then
			_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
		fi
		if [[ "$(echo "$_INDEX" | command grep -v '^##')x" == "x" ]]; then
			_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
		fi
	else
		_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
	fi

	if $(command git rev-parse --verify refs/stash &> /dev/null); then
		_STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
	fi

	echo $_STATUS
}

jamesl_git_prompt () {
	local _branch=$(jamesl_git_branch)
	local _status=$(jamesl_git_status)
	local _result=""
	if [[ "${_branch}x" != "x" ]]; then
		_result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
		if [[ "${_status}x" != "x" ]]; then
			_result="$_result $_status"
		fi
		_result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
	echo $_result
}


if [[ $EUID -eq 0 ]]; then
	_USERNAME="%{$fg_bold[red]%}%n"
	_LIBERTY="%{$fg[red]%}#"
else
	_USERNAME="%{$fg_bold[white]%}%n"
	_LIBERTY="%{$fg[green]%}$"
fi
_USERNAME="$_USERNAME%{$reset_color%}@%m"
_LIBERTY="$_LIBERTY%{$reset_color%}"

get_space () {
	local STR=$1$2
	local STR_LEFT=$1
	local zero='%([BSUbfksu]|([FB]|){*})'
	local LINE_LEFT=${(S%%)STR_LEFT//$~zero/}
	local LINE_DATA=${(S%%)STR//$~zero/}
	LINE_DATA=${LINE_DATA//\\[/[[}
	LINE_DATA=${LINE_DATA//\[\[[0-9][0-9]m/}
	LINE_DATA=${LINE_DATA//\[\[[0-9]m/}
	LINE_DATA=${LINE_DATA//\[\[[0-9][0-9];[0-9];[0-9][0-9]m/}
	LINE_DATA=${LINE_DATA//\[\[[0-9][0-9];[0-9];[0-9][0-9][0-9]m/}
	LINE_LEFT=${LINE_LEFT//\\[/[[}
	LINE_LEFT=${LINE_LEFT//\[\[[0-9][0-9]m/}
	LINE_LEFT=${LINE_LEFT//\[\[[0-9]m/}
	LINE_LEFT=${LINE_LEFT//\[\[[0-9][0-9];[0-9];[0-9][0-9]m/}
	LINE_LEFT=${LINE_LEFT//\[\[[0-9][0-9];[0-9];[0-9][0-9][0-9]m/}
	# replace [ to [[
	local WORDS_LENGTH=${#${LINE_DATA}}
	local LEFT_LENGTH=${#${LINE_LEFT}}
	local SPACES_COUNT=0
	local SPACES=""
	local LENGTH=0

	if [[ $LEFT_LENGTH -gt (($COLUMNS -1 )) ]]; then
		(( LENGTH =${COLUMNS} + ${COLUMNS} - $WORDS_LENGTH - 1))

		for i in {0..$LENGTH}; do
			(( SPACES_COUNT = ${SPACES_COUNT} + 1))
			SPACES="$SPACES "
		done
		echo $SPACES
		return
	fi

	if [[ $WORDS_LENGTH -gt (($COLUMNS -1 )) ]]; then
		echo "NULL"
		return
	fi

	(( LENGTH =${COLUMNS} - $WORDS_LENGTH - 1))

	for i in {0..$LENGTH}; do
		(( SPACES_COUNT = ${SPACES_COUNT} + 1))
		SPACES="$SPACES "
	done
	# echo "str:---->>>> ${#${LINE_DATA}}: $LINE_DATA <<<<----" > ~/1.log
	# echo "str:---->>>> ${#${LINE_DATA}}: $LINE_DATA <<<<----"
	# echo "SPACES_COUNT: $SPACES_COUNT, LENGTH: $LENGTH, WORDS_LENGTH: $WORDS_LENGTH,"
	# echo "SPACES len: ${#SPACES},COLUMNS: $COLUMNS"
	echo $SPACES
}


prompt_jamesl_precmd() {
	PRE_CMD_RET=$?
	vcs_info

	# _PATH="%{$fg_bold[white]%}%~%{$reset_color%}"
	# _1LEFT="$_USERNAME $_PATH"
	# _1RIGHT="[%*] "

	LINE_ONE_LEFT_SYMB=`print $LINK_UP`
	_1LEFT='%{%f%b%k%}$(prompt_jamesl_line_one left) '
	_1RIGHT='$(prompt_jamesl_line_one right)'
	_1SPACES=`get_space $_1LEFT $_1RIGHT`
	if [[ $_1SPACES == "NULL" ]]; then
		_1RIGHT='$(prompt_jamesl_line_two left)'
		_1LINE="$_1LEFT"
		_2LINE="$_1RIGHT"
	else
		# _1LINE="$_1LEFT$_1SPACES$_1RIGHT"
		_1LINE="$_1LEFT"
	fi

	print -rP "$_1LINE"
	if [[ $_1SPACES == "NULL" ]]; then
		print -rP "$_2LINE"
	fi

	setopt prompt_subst
	PROMPT='> $_LIBERTY '
	# RPROMPT='$(nvm_prompt_info) $(date +%H:%M:%S)'
	# RPROMPT='[38;5;254m$(nvm_prompt_info) $(date +%H:%M:%S)[0m'
	# PROMPT='$(prompt_jamesl_left)'
	# PROMPT='$(prompt_jamesl_left)'
	# PROMPT='%{%f%b%k%}$(prompt_jamesl_left)'
	# PROMPT=$(print -n "[38;5;248m $SEGMENT_SEPARATOR_LEFT[0m")
	if [[ "${ZSH_THEME_DISABLE_LINK_UP_DOWN}x" == "truex" ]]; then
		PROMPT=$(print -n "$SEGMENT_SEPARATOR_LEFT ")
	else
		PROMPT=$(print -n "${LINK_DOWN}$SEGMENT_SEPARATOR_LEFT ")
	fi
	# PROMPT=$(print -n "\[\e\[38;5;248m\]\]$SEGMENT_SEPARATOR_LEFT\[\e\[0m\]\]")
	# RPROMPT='$(prompt_jamesl_right)'

}

prompt_jamesl_setup() {
	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info

	prompt_opts=(cr subst percent)

	add-zsh-hook precmd prompt_jamesl_precmd

	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' check-for-changes false
	zstyle ':vcs_info:git*' formats '%b'
	zstyle ':vcs_info:git*' actionformats '%b (%a)'
}


prompt_jamesl_setup "$@"
