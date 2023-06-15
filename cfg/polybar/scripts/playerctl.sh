#!/bin/bash

# The name of polybar bar which houses the main spotify module and the control modules.
[[ -f "$HOME/.zprofile" ]] && source "$HOME/.zprofile"
[[ -z "$bar_style" ]] && bar_style="base"
[[ "$bar_style" == "base" ]] && PARENT_BAR="bottom" || PARENT_BAR="main"

PARENT_BAR_PID=$(pgrep -a "polybar" | grep "$PARENT_BAR" | awk '{print $1}')

# Sends $2 as message to all polybar PIDs that are part of $1
update_hooks() {
    while IFS= read -r id ;do
        polybar-msg -p "$id" hook playerctl-playpause "$2" 1>/dev/null 2>&1
    done <<< "$1"
}

# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata
Format="{{ title }}: {{ artist }}"

player() {
	Current="$(playerctl metadata --format "$Format" 2>/dev/null)"
	PlayerName="$(playerctl -l | head -n1 | cut -f1 -d ".")"
	case $PlayerName in
	  spotify) echo "$Current  " ;;
	  firefox) echo "$Current  " ;;
	  kdeconnect) echo "$Current  " ;;  
	  vlc) echo "$Current 嗢 " ;;  
	  mpv) echo "$Current  " ;;  
	  rhythmbox) echo "$Current 蓼 " ;;
	  *) echo "$Current" ;;
	esac
}

PLAYERCTL_STATUS=$(playerctl status 2>/dev/null)

if [ $? -eq 0 ]; then
    STATUS=$PLAYERCTL_STATUS
else
    STATUS="No player is running"
fi

case "$1" in
    "--status")
        echo "$STATUS"
        ;;
    "--name" | "--name-minimal")
        if [ "$STATUS" = "Stopped" ]; then
            echo "No music is playing"
        elif [ "$STATUS" = "Paused"  ]; then
            update_hooks "$PARENT_BAR_PID" 2
            player
        elif [ "$STATUS" = "No player is running" ]; then
            if [ "$1" = "--name-minimal" ]; then
       	        echo ""
                update_hooks "$PARENT_BAR_PID" 3
            else
                echo "Doesn't look like anything to me"
            fi
        else
            update_hooks "$PARENT_BAR_PID" 1
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
