##!/bin/bash

cache_dir="$HOME/.cache/eww"
cache="$cache_dir/control-center.eww"
config="$HOME/.config/eww"

[ ! -d $cache_dir ] && mkdir $cache_dir

#if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then 
	#_eww=eww-wayland
	### change the controls window location based on the display server
	#sed -i 's/:x .*/:x "4.2%"/g' ~/.config/eww/controls/controls.yuck
	#sed -i 's/:y .*/:y "31.25%"/g' ~/.config/eww/controls/controls.yuck
	#sed -i 's/:x .*/:x "4.2%"/g' ~/.config/eww/notifications/notification-panel.yuck 
	#sed -i 's/:y .*/:y "43%"/g' ~/.config/eww/notifications/notification-panel.yuck 
#else
	#_eww=eww
	### change the controls window location based on the display server
	#sed -i 's/:x .*/:x "-0.5%"/g' ~/.config/eww/controls/controls.yuck
	#sed -i 's/:y .*/:y "3.1%"/g' ~/.config/eww/controls/controls.yuck
	#sed -i 's/:x .*/:x "-10px"/g' ~/.config/eww/notifications/notification-panel.yuck 
	#sed -i 's/:y .*/:y "33px"/g' ~/.config/eww/notifications/notification-panel.yuck 
 #fi

open() {
	touch $cache
	eww -c $config open controls &&
	[[ $(pgrep polybar) ]] && polybar-msg action "#control.hook.0"	
}

close() {
	rm $cache
	eww -c $config close controls &&
	[[ $(pgrep polybar) ]] && polybar-msg action "#control.hook.1"
	
}

#notification(){
	#eww open --toggle notification-panel
	#}
	
main(){
	if [[ ! $(pidof eww) ]]; then
		eww -c $config daemon &
		sleep 0.5 &&
		main
	else
		if [ ! -f $cache ]; then
			open
		else
			close
		fi
	fi
}
main
#if [[ ! "$1" ]];then main ;else notification ;fi
