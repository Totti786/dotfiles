#!/bin/bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CARD="$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)"
INTERFACE="$(ip link | awk '/state UP/ {print $2}' | tr -d :)"
BATTERY=$(upower -i `upower -e | grep 'BAT'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
ADAPTER=$(upower -i `upower -e | grep 'AC'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
current_desktop=$(wmctrl -m |sed -n 1p | sed -e 's/Name: //g') 

if [[ -f ~/.profile ]]; then 
	source ~/.profile
else
	style="base"
	tp="23"
	bp="23"
fi

# Fix backlight and network modules
fix_modules() {
	# check the graphics card and adjust the backlight module accordingly
	if [[ -z "$CARD" ]]; then
		sed -i -e 's/sep backlight/bna/g' 								   "$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		sed -i -e 's/sep brightness/bna/g' 								   "$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	elif [[ "$CARD" != *"intel_"* ]]; then
		sed -i -e 's/backlight/brightness/g' 							   "$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	else 
		sed -i -e 's/bna/sep backlight/g' 								   "$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
	fi
			
	# check if bspwm is the curren wm and changes the workspaces module 
	if [[ $current_desktop == "bspwm" ]]; then
		sed -i -e 's/modules-center = workspaces/modules-center = bspwm/g'  "$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		sed -i -e 's/override-redirect = .*/override-redirect = true/g' 	"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		sed -i -e 's/titlex\b/title/g' 										"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		sed -i -e 's/wm-restack = .*/wm-restack = bspwm/g' 					"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		bspc config -m focused top_padding $tp
		bspc config -m focused bottom_padding $bp
	else 
		sed -i -e 's/modules-center = bspwm/modules-center = workspaces/g' 	"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		sed -i -e 's/override-redirect = .*/override-redirect = false/g'    "$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		sed -i -e 's/title\b/titlex/g' 										"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		sed -i -e 's/wm-restack = .*/wm-restack = /g' 						"$DIR"/config.ini "$DIR"/minimal/config-minimal.ini 
		openbox --reconfigure                                                                                                                                                
	fi
}

## Write values to `system` file
set_values() {
	if [[ "$ADAPTER" ]]; then
		sed -i -e "s/adapter = .*/adapter = $ADAPTER/g" 						$DIR/system.ini
	fi
	if [[ "$BATTERY" ]]; then
		sed -i -e "s/battery = .*/battery = $BATTERY/g" 						$DIR/system.ini
	fi
	if [[ "$CARD" ]]; then
		sed -i -e "s/graphics_card = .*/graphics_card = $CARD/g" 				$DIR/system.ini
	fi
	if [[ "$INTERFACE" ]]; then
		sed -i -e "s/network_interface = .*/network_interface = $INTERFACE/g" 	$DIR/system.ini
	fi	
}

# Launch the bar
launch_bar() {
	# Terminate already running bar instances
	killall -q -9 polybar
	killall -q -9 updates.sh zscroll playerctl-scroll.sh
	# Launch the bar
	if [ $style == "base" ]; then 
		polybar -q top -c "$DIR"/config.ini &
		polybar -q bottom -c "$DIR"/config.ini &
	elif [ $style == "minimal" ]; then 
		polybar -q bottom -c "$DIR"/minimal/config-minimal.ini &
	fi
}

set_values
fix_modules
launch_bar
