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
	[[ $(pgrep polybar) ]] && polybar-msg action "#control.hook.0"
	eww -c $config open controls
	touch $cache
}

close() {
	[[ $(pgrep polybar) ]] && polybar-msg action "#control.hook.1"
	eww -c $config close controls
	rm $cache
}

#notification(){
	#eww open --toggle notification-panel
	#}
	
#main(){
	#if [[ ! `pidof $_eww` ]]; then
		#$_eww -c $config daemon &
		#sleep 0.5 &&
		#run
	#else
		if [ ! -f $cache ]; then
			open
		else
			close
		fi
	#fi
#}

#if [[ ! "$1" ]];then main ;else notification ;fi
