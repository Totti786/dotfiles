#!/bin/bash

cache_dir="$HOME/.cache/eww"
cache="$cache_dir/control-center.eww"
active_players="$(playerctl -l | head -n 1)"

[ ! -d $cache_dir ] && mkdir $cache_dir

if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then 
	_eww=eww-wayland
	
	## change the controls window location based on the display server
	sed -i 's/:x .*/:x "4.2%"/g' ~/.config/eww/controls/controls.yuck
	sed -i 's/:y .*/:y "31.25%"/g' ~/.config/eww/controls/controls.yuck
	
	sed -i 's/:x .*/:x "4.2%"/g' ~/.config/eww/notifications/notification-panel.yuck 
	sed -i 's/:y .*/:y "43%"/g' ~/.config/eww/notifications/notification-panel.yuck 

else
	_eww=eww

	## change the controls window location based on the display server
	sed -i 's/:x .*/:x "-0.5%"/g' ~/.config/eww/controls/controls.yuck
	sed -i 's/:y .*/:y "3.1%"/g' ~/.config/eww/controls/controls.yuck

	sed -i 's/:x .*/:x "-10px"/g' ~/.config/eww/notifications/notification-panel.yuck 
	sed -i 's/:y .*/:y "33px"/g' ~/.config/eww/notifications/notification-panel.yuck 
 
fi

listen(){
	while true ; do 
		if [[ ! -z "$(playerctl -l | head -n 1)" ]] &> /dev/null; then
			eww update music-panel=true
		else 
			eww update music-panel=false
		fi
		sleep 0.5
	done 
}

run() {
	eww open controls
	[[ `pgrep polybar` ]] && polybar-msg action "#control.hook.0"
	touch $cache
	sleep 0.1 && listen &
}

close() {
	[[ ! -z $active_players ]] && eww update music-panel=false
	eww close-all
	[[ `pgrep polybar` ]] && polybar-msg action "#control.hook.1"
	eww update timer_reveal=false
	rm $cache
	killall -9 controls.sh
}

notification(){
	eww open --toggle notification-panel
	}
	
main(){
	if [[ ! `pidof $_eww` ]]; then
		$_eww daemon &
		sleep 0.5 &&
		run
	else
		if [ ! -f $cache ]; then
			run
		else
			close
		fi
	fi
}

if [[ ! "$1" ]];then main ;else notification ;fi
