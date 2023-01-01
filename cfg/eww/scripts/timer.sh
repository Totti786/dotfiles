#!/bin/bash

timer="$HOME/.cache/eww/timer"

count() {
	yad="`zenity --scale --text="Choose the number of minutes: " --value=5 --min-value=0 --max-value=120`"
    start="$(( $(date +%s) + $((60 * $yad))))"
    while [ "$start" -ge $(date +%s) ] && [ -f $timer ] ; do
        time="$(( $start - `date +%s` ))"
		echo "$(date -u -d "@$time" +%H:%M:%S)" > $timer
        sleep 0.1
    done && rm $timer && mpv ~/.config/eww/scripts/assets/ring.mp3
}

stop(){
	now=$(date +%s)sec
	while [ -f $timer ]; do
		echo $(TZ=UTC date --date now-$now +%H:%M:%S) > $timer
		sleep 1
	done
}

stop_watch(){
	if [ ! -f $timer ]; then
		touch $timer
		stop &
	else
		rm $timer
	fi
}

count_down(){
	if [ ! -f $timer ]; then
		touch $timer
		count &
	else
		rm $timer
	fi
}

toggle(){
	if [ "$(eww get timer_reveal)" == "false" ]; then 
		eww update timer_reveal=true
	else
		eww update timer_reveal=false
	fi
	}

status(){
	if [ ! -f $timer ]; then
		echo "Timer"
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
    countdown)
        count_down
        ;;
    stopwatch)
        stop_watch
        ;;
esac
