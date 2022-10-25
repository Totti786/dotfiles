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
Format="{{ title }}: {{ artist }}"
Duration="{{duration(position) }} "/" {{ duration(mpris:length)}}"

player(){
	Current="$(playerctl metadata --format "$Format")"
	PlayerName="$(playerctl -l | head -n1 | cut -f1 -d ".")"
	case $PlayerName in
	  spotify) echo $Current 
	  ;;
	  firefox) echo $Current 
	  ;;
	  kdeconnect) echo $Current 
	  ;;  
	  vlc) echo $Current 
	  ;;  
	  mpv) echo $Current 
	  ;;  
	  rhythmbox) echo $Current 
	  ;;
	  *) echo $Current
	esac
}
duration(){
	CurrentD="$(playerctl metadata --format "$Duration")"
	PlayerName="$(playerctl -l | head -n1 | cut -f1 -d ".")"
	case $PlayerName in
	  spotify) echo " $CurrentD "
	  ;;
	  firefox) echo " "
	  ;;
	  kdeconnect) echo " $CurrentD "
	  ;;  
	  vlc) echo " $CurrentD 嗢"
	  ;;  
	  mpv) echo " $CurrentD "
	  ;;  
	  rhythmbox) echo " $CurrentD 蓼"
	  ;;
	  *) echo ""
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
elif [ "$1" == "--name" ]; then
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
elif [ "$1" == "--duration" ]; then
	 if [ "$STATUS" = "Stopped" ]; then
        echo ""
    elif [ "$STATUS" = "Paused"  ]; then
        duration
    elif [ "$STATUS" = "No player is running"  ]; then
        echo ""
    else
		duration
	fi
fi
