##!/bin/bash

cache_dir="$HOME/.cache/eww"
cache="$cache_dir/control-center.eww"
config="$HOME/.config/eww"

if [ -f "$HOME/.zprofile" ]; then source "$HOME/.zprofile" ; else  bar_style="base" ;fi
[ ! -d $cache_dir ] && mkdir $cache_dir


open() {
	touch $cache
	[[ "$XDG_SESSION_TYPE" == "x11" ]] && eww -c $config open --toggle background-closer
	eww -c $config open controls-"$XDG_SESSION_TYPE"-"$bar_style" &&
	[[ $(pgrep polybar) ]] && polybar-msg action "#control.hook.0"
	}

close() {
	rm $cache
	[[ -z "$(playerctl -sl | head -n 1)" ]] && eww -c $config update music-panel=false
	eww -c $config close-all &&
	[[ $(pgrep polybar) ]] && polybar-msg action "#control.hook.1"
}

notification(){
	eww -c $config open --toggle notification-panel-"$XDG_SESSION_TYPE"-"$bar_style"
	}

main(){
	if [[ ! $(pidof eww) ]] && [[ "$XDG_SESSION_TYPE" == "x11" ]] ; then
		[[ $(pidof eww-wayland) ]] && pkill eww 
		eww -c $config daemon &
		sleep 0.5 &&
		main
	elif [[ ! $(pidof eww-wayland) ]] && [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then 
		[[ $(pidof eww) ]] && pkill eww 
		eww-wayland -c $config daemon &
		sleep 0.5 &&
		main
	else
		if [ ! -f $cache ]; then open ;else	close ;fi
	fi
}

if [[ ! "$1" ]];then main ;else notification ;fi
