#!/usr/bin/env bash

cache_dir="$HOME/.cache/eww"
cache="$cache_dir/control-center.eww"
config="$HOME/.config/eww"
_eww="$config/eww"

[[ -f "$HOME/.theme" ]] && source "$HOME/.theme"
[[ -z "$bar_style" ]] && bar_style="base" top_padding="23" bottom_padding="23"
[[ "$top_padding" == "0" ]] && anchor="bottom right" padding="-$(( $bottom_padding + 10))" || anchor="top right" padding="$(( $top_padding + 10))"

[ ! -d $cache_dir ] && mkdir $cache_dir

open() {
	touch $cache
	#sed -i -e "s/:y .*/:y \"${padding}\"/" \
		  #  -e "s/:anchor .*/:anchor \"$anchor\"/"  \
		#"$config/controls/controls.yuck"
	$_eww -c $config open controls &&
	[[ $(pgrep polybar) ]] && polybar-msg action "#control.hook.0"
	}

close() {
	rm $cache
	[[ -z "$(playerctl -sl | head -n 1)" ]] && $_eww -c $config update music-panel=false
	$_eww -c $config close-all &&
	[[ $(pgrep polybar) ]] && polybar-msg action "#control.hook.1"
}

notification(){
	sed -i -e "s/:y .*/:y \"${padding}\"/" \
		   -e "s/:anchor .*/:anchor \"$anchor\"/" \
	"$config/notifications/notification-panel.yuck"
	$_eww -c $config open --toggle notification-panel
	}

main(){
	if ! [[ $(pidof eww) ]]; then
		sed -i -e "s/:y .*/:y \"${padding}\"/" \
		    -e "s/:anchor .*/:anchor \"$anchor\"/"  \
		"$config/controls/controls.yuck" "$config/notifications/notification-panel.yuck"
		$_eww -c $config daemon &
		sleep 0.5 &&
		main
	else
		if [ ! -f $cache ]; then open ;else	close ;fi
	fi
}

if [[ ! "$1" ]];then main ;else notification ;fi
