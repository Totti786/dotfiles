#!/bin/bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CARD="$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)"
INTERFACE="$(ip link | awk '/state UP/ {print $2}' | tr -d :)"
BATTERY=$(upower -i `upower -e | grep 'BAT'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
ADAPTER=$(upower -i `upower -e | grep 'AC'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
current_desktop=$(wmctrl -m |sed -n 1p | sed -e 's/Name: //g') 

if [[ -f "$HOME"/.profile ]]; then 
	source "$HOME"/.profile
else
	style="base" tp="23" bp="23"
fi

# Fix backlight and network modules
fix_modules() {
	# check the graphics card and adjust the backlight module accordingly
	if [[ -z "$CARD" ]]; then
		sed -i -e 's/sep backlight/bna/g' 								   		"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		sed -i -e 's/sep brightness/bna/g' 								   		"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	elif [[ "$CARD" != *"intel_"* ]]; then
		sed -i -e 's/backlight/brightness/g' 							   		"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	else
		sed -i -e 's/bna/sep backlight/g' 								   		"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	fi

	# check if bspwm is the curren wm and changes the workspaces module 
	if [[ $current_desktop == "bspwm" ]]; then
		bspc config -m focused top_padding $tp
		bspc config -m focused bottom_padding $bp
		sed -i -e 's/modules-center = workspaces/modules-center = bspwm/g' \
			-i -e 's/override-redirect = .*/override-redirect = true/g' \
			-i -e 's/titlex\b/title/g' \
			-i -e 's/wm-restack = .*/wm-restack = bspwm/g' 						"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	elif [[ $current_desktop == "i3" ]]; then
		sed -i -e 's/modules-center = bspwm/modules-center = workspaces/g' \
			-i -e 's/override-redirect = .*/override-redirect = false/g' \
			-i -e 's/titlex\b/title/g' \
			-i -e 's/wm-restack = .*/wm-restack = i3/g' 						"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	elif [[ $current_desktop == "Openbox" ]]; then
		openbox --reconfigure
		sed -i -e 's/modules-center = bspwm/modules-center = workspaces/g' \
			-i -e 's/override-redirect = .*/override-redirect = false/g' \
			-i -e 's/title\b/titlex/g' \
			-i -e 's/wm-restack = .*/wm-restack = /g' 							"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	fi
}

## Write values to `system` file
set_values() {
	[[ "$ADAPTER" ]] &&
		sed -i -e "s/adapter = .*/adapter = $ADAPTER/g" 						"$DIR"/system.ini
	[[ "$BATTERY" ]] &&
		sed -i -e "s/battery = .*/battery = $BATTERY/g" 						"$DIR"/system.ini
	[[ "$CARD" ]] &&
		sed -i -e "s/graphics_card = .*/graphics_card = $CARD/g" 				"$DIR"/system.ini
	[[ "$INTERFACE" ]] &&
		sed -i -e "s/network_interface = .*/network_interface = $INTERFACE/g" 	"$DIR"/system.ini
}

# Launch the bar
launch_bar() {
	# Terminate already running bar instances
	killall -q -9 polybar
	killall -q -9 updates.sh zscroll playerctl-scroll.sh
	# Launch the bar
	if [[ "$style" == "base" ]]; then 
		polybar -q top -c "$DIR"/config.ini &
		polybar -q bottom -c "$DIR"/config.ini &
	elif [[ "$style" == "minimal" ]]; then
		polybar -q main -c "$DIR"/minimal/config-minimal.ini &
	fi
}

set_values
fix_modules
launch_bar
