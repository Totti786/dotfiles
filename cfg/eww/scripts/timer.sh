#!/bin/bash

countdown() {
    start="$(( $(date +%s) + $(yad --borders=10 --width='300' --title='Timer Minutes' --button=Cancel:1 --button=Okay:0  --scale --value=5 --min-value=0 --max-value=360)))"
    while [ "$start" -ge $(date +%s) ]; do
        ## Is this more than 24h away?
        days="$(($(($(( $start - $(date +%s) )) * 1 )) / 86400))"
        time="$(( $start - `date +%s` ))"
        printf '%s day(s) and %s\r' "$days" "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 0.1
    done
}

timer="$HOME/.cache/eww/timer"
toggle(){
	if [ ! -f $timer ]; then
		touch $timer
		sh ~/.config/eww/scripts/stopwatch &
	else
		rm $timer
	fi
}

#toggle(){
	#if [ "$(eww get note)" == "false" ]; then 
		#eww update note=true
	#else
		#eww update note=false
	#fi
	#}

status(){
	if [ ! -f $timer ]; then
		echo "Stopwatch"
	else
		cat ~/.cache/eww/timer
	fi
}


case $1 in
    toggle)
        toggle
        ;;
    status)
        status
        ;;
    count)
        countdown
        ;;
esac
