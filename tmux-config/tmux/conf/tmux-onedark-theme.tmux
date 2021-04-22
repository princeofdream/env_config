#!/bin/bash
onedark_black="#282c34"
onedark_blue="#61afef"
onedark_yellow="#e5c07b"
onedark_red="#e06c75"
onedark_white="#aab2bf"
onedark_green="#98c379"
onedark_purper="#5f5fd7"
onedark_grey_white="#7a7a7a"
onedark_visual_grey="#3e4452"
onedark_light_blue="#5f87af"
onedark_light_grey="#747495"
onedark_comment_grey="#5c6370"

get() {
   local option=$1
   local default_value=$2
   local option_value="$(tmux show-option -gqv "$option")"

   if [ -z "$option_value" ]; then
      echo "$default_value"
   else
      echo "$option_value"
   fi
}

set() {
   local option=$1
   local value=$2
   tmux set-option -gq "$option" "$value"
}

setw() {
   local option=$1
   local value=$2
   tmux set-window-option -gq "$option" "$value"
}

set "status" "on"
set "status-justify" "left"

set "status-left-length" "100"
set "status-right-length" "100"
set "status-right-attr" "none"

set "message-fg" "$onedark_white"
set "message-bg" "$onedark_black"

set "message-command-fg" "$onedark_white"
set "message-command-bg" "$onedark_black"

set "status-attr" "none"
set "status-left-attr" "none"

setw "window-status-fg" "$onedark_black"
setw "window-status-bg" "$onedark_black"
setw "window-status-attr" "none"

setw "window-status-activity-bg" "$onedark_purper"
setw "window-status-activity-fg" "$onedark_purper"
setw "window-status-activity-attr" "none"

setw "window-status-separator" ""

set "window-style" "fg=$onedark_comment_grey"
set "window-active-style" "fg=$onedark_white"

set "pane-border-fg" "$onedark_white"
set "pane-border-bg" "$onedark_black"
set "pane-active-border-fg" "$onedark_green"
set "pane-active-border-bg" "$onedark_black"

set "display-panes-active-colour" "$onedark_yellow"
set "display-panes-colour" "$onedark_blue"

set "status-bg" "$onedark_black"
set "status-fg" "$onedark_white"

set "@prefix_highlight_fg" "$onedark_red"
set "@prefix_highlight_bg" "$onedark_yellow"
set "@prefix_highlight_copy_mode_attr" "fg=$onedark_black,bg=$onedark_green"
set "@prefix_highlight_output_prefix" "⌨"

status_widgets=$(get "@onedark_widgets")
status_widgets_lilght_grey_bg=$(get "@onedark_widgets_light_grey_bg")
status_widgets_lilght_blue_bg=$(get "@onedark_widgets_light_blue_bg")
status_widgets_green_bg=$(get "@onedark_widgets_green_bg")
status_widgets_purper_bg=$(get "@onedark_widgets_purper_bg")
time_format=$(get "@onedark_time_format" "%R")
date_format=$(get "@onedark_date_format" "%d/%m/%Y")

set "status-right" "#[fg=$onedark_white,bg=$onedark_black,nounderscore,noitalics]${time_format} \
	${date_format} \
	#[fg=$onedark_visual_grey,bg=$onedark_black]\
	#[fg=$onedark_visual_grey,bg=$onedark_visual_grey]\
	#[fg=$onedark_white, bg=$onedark_visual_grey]${status_widgets}\
	#[fg=$onedark_light_grey,bg=$onedark_visual_grey]\
	#[fg=$onedark_black, bg=$onedark_light_grey]${status_widgets_lilght_grey_bg}\
	#[fg=$onedark_light_blue,bg=$onedark_light_grey]\
	#[fg=$onedark_black, bg=$onedark_light_blue]${status_widgets_lilght_blue_bg}\
	#[fg=$onedark_purper,bg=$onedark_light_blue]\
	#[fg=$onedark_black,bg=$onedark_purper,bold]${status_widgets_purper_bg}\
	#[fg=$onedark_green,bg=$onedark_purper,nobold,nounderscore,noitalics]\
	#[fg=$onedark_black,bg=$onedark_green,bold]${status_widgets_green_bg}\
	#[fg=$onedark_yellow, bg=$onedark_green]\
	#[fg=$onedark_red,bg=$onedark_yellow]\
	#{prefix_highlight}#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#{?window_zoomed_flag,[Z],}\
	#[fg=$onedark_red,bg=$onedark_yellow,bold]${status_widgets_green_bg}"
# set "status-right" "#[fg=$onedark_white,bg=$onedark_black,nounderscore,noitalics]${time_format}  ${date_format} #[fg=$onedark_visual_grey,bg=$onedark_black]#[fg=$onedark_visual_grey,bg=$onedark_visual_grey]#[fg=$onedark_white, bg=$onedark_visual_grey]${status_widgets} #[fg=$onedark_green,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_black,bg=$onedark_green,bold] #h #[fg=$onedark_yellow, bg=$onedark_green]#[fg=$onedark_red,bg=$onedark_yellow]"
set "status-left" "#[fg=$onedark_black,bg=$onedark_green,bold] #S #[fg=$onedark_green,bg=$onedark_black,nobold,nounderscore,noitalics]"

set "window-status-format" "#[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]\
	#[fg=$onedark_grey_white,bg=$onedark_black]#I \
	#[fg=$onedark_grey_white,bg=$onedark_black]#W \
	#[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]"

set "window-status-current-format" "#[fg=$onedark_black,bg=$onedark_blue,nobold,nounderscore,noitalics]\
	#[fg=$onedark_comment_grey,bg=$onedark_blue,bold]*#I\
	#[fg=$onedark_black,bg=$onedark_blue,bold]#W \
	#[fg=$onedark_blue,bg=$onedark_black,nobold,nounderscore,noitalics]"

