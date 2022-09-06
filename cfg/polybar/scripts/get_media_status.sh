#!/bin/bash

# The name of polybar bar which houses the main spotify module and the control modules.
PARENT_BAR="bottom"
PARENT_BAR_PID=$(pgrep -a "polybar" | grep "$PARENT_BAR" | cut -d" " -f1)

# Sends $2 as message to all polybar PIDs that are part of $1
update_hooks() {
    while IFS= read -r id
    do
        polybar-msg -p "$id" hook playerctl-playpause $2 1>/dev/null 2>&1
    done < <(echo "$1")
}

# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata
#FORMAT1="{{ title }} - {{ artist }} - {{duration(position) }} "/" {{ duration(mpris:length)}}"
FORMAT="{{ title }}: {{ artist }}"

player(){
Current="$(playerctl metadata --format "$FORMAT")"
#Current1="$(playerctl metadata --format "$FORMAT1")"
PlayerName="$(playerctl -l | head -n1 | cut -f1 -d ".")"
	case $PlayerName in
	  spotify) echo $Current 
	  ;;
	  firefox) echo $Current 
	  ;;
	  kdeconnect) echo $Current 
	  ;;  
	  vlc) echo $Current 嗢
	  ;;  
	  rhythmbox) echo $Current 蓼
	  ;;
	  *) echo $Current
	esac
}

PLAYERCTL_STATUS=$(playerctl status 2>/dev/null)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    STATUS=$PLAYERCTL_STATUS
else
    STATUS="No player is running"
fi

if [ "$1" == "--status" ]; then
    echo "$STATUS"
else
    if [ "$STATUS" = "Stopped" ]; then
        echo "No music is playing"
    elif [ "$STATUS" = "Paused"  ]; then
        update_hooks "$PARENT_BAR_PID" 2
        player
    elif [ "$STATUS" = "No player is running"  ]; then
        echo "Doesn't look like anything to me"
    else
        update_hooks "$PARENT_BAR_PID" 1
		player
    fi
fi
