#!/bin/bash

cache_dir="$HOME/.cache/eww"
cache="$cache_dir/control-center.eww"
active_players="$(playerctl -l | head -n 1)"

[ ! -d $cache_dir ] && mkdir $cache_dir
#sh ~/.config/eww/scripts/tools.sh datecover

listen(){
	while true ; do 
		#id=$(wmctrl -l | awk '{print $1}' | xprop -root | grep _NET_ACTIVE_WINDOW | head -1 | awk '{print $5}' | sed 's/,//' | sed 's/^0x/0x0/')
		#check=$(echo $(xwininfo -all -id $id | grep Fullscreen))
		#if [[ $check == "Fullscreen" ]]; then
			#xdo lower -N eww-controls
		#else
			#xdo raise -N eww-controls
		#fi 
	
		if [[ ! -z "$(playerctl -l | head -n 1)" ]] &> /dev/null; then
			eww update music-panel=true
		else 
			eww update music-panel=false
		fi
		sleep 0.5
	done 
}

run () {
	eww open controls
	polybar-msg action "#control.hook.0"
	touch $cache
	sleep 0.1 && listen &
}

if [[ ! `pidof eww` ]]; then
	eww daemon &
	sleep 0.5 &&
	run
else
	if [ ! -f $cache ]; then
		run
	else
		[[ ! -z $active_players ]] && eww update music-panel=false
		eww close-all
		polybar-msg action "#control.hook.1"
		eww update timer_reveal=false
		rm $cache
		killall -9 controls.sh
	fi
fi
