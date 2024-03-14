#!/usr/bin/env bash

# The name of polybar bar which houses the main spotify module and the control modules.
[[ -f "$HOME/.theme" ]] && source "$HOME/.theme"
[[ -z "$bar_style" ]] && bar_style="base"
[[ "$bar_style" == "base" ]] && parent_bar="bottom" || parent_bar="main"

parent_bar_id=$(pgrep -a "polybar" | grep "$parent_bar" | awk '{print $1}')

# Sends $2 as message to all polybar PIDs that are part of $1
update_hooks() {
    while IFS= read -r id ;do
        polybar-msg -p "$id" hook playerctl-playpause "$2" 1>/dev/null 2>&1
    done <<< "$1"
}

# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata
if [[ -z $(playerctl metadata --format "{{ artist }}") ]] 2>/dev/null; then
	format="{{ title }}"
else
	format="{{ title }}: {{ artist }}"
fi

player() {
	current="$(playerctl metadata --format "$format" 2>/dev/null)"
	player_name="$(playerctl -l | head -n1 | cut -f1 -d ".")"
	declare -A player_icons=(
		["spotify"]=""
		["firefox"]=""
		["kdeconnect"]=""
		["vlc"]="嗢"
		["mpv"]=""
		["rhythmbox"]="蓼"
	)
	
	icon="${player_icons[$player_name]}"
	echo "$current ${icon:-}"
}

playerctl_status=$(playerctl status 2>/dev/null)

if [ $? -eq 0 ]; then
    status="$playerctl_status"
else
    status="No player is running"
fi

case "$1" in
    "--status")
        echo "$status"
        ;;
    "--name" | "--name-minimal")
        if [ "$status" = "Stopped" ]; then
            echo "No music is playing"
        elif [ "$status" = "Paused"  ]; then
            update_hooks "$parent_bar_id" 2
            player
        elif [ "$status" = "No player is running" ]; then
            if [ "$1" = "--name-minimal" ]; then
       	        echo ""
                update_hooks "$parent_bar_id" 3
            else
                echo "Doesn't look like anything to me"
            fi
        else
            update_hooks "$parent_bar_id" 1
            player
        fi
        ;;
    "--scroll")
		zscroll -l 50 \
	        --delay 0.7 \
	        --scroll-padding " " \
	        --match-command "$0 --status" \
	        --match-text "Playing" "--scroll 1" \
	        --match-text "Paused" "--scroll 0" \
	        --update-check true "$0 --name" &
		wait
        ;;
esac
