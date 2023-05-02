#!/usr/bin/env bash

#This is a bash script that reads system information and adjusts configuration 
#files for a Linux desktop environment. It first sets some variables based on the output of various 
#system commands, such as the graphics card and network interface. 
#It then uses these variables to modify configuration files based on the current 
#desktop environment (e.g., bspwm, herbstluftwm, i3, or Openbox) and the availability 
#of certain modules (e.g., backlight or network modules). Finally, it writes some of these
#variables to a "system" file.


dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
graphics_card="$(light -L | grep -m1 'backlight' | cut -d'/' -f3)"
network_interface="$(ip link | awk '/state UP/ {print $2}' | tr -d :)"
battery_name=$(upower -i "$(upower -e | grep 'BAT')" | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
adapter_name=$(upower -i "$(upower -e | grep 'AC')" | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
current_desktop=$(wmctrl -m |sed -n 1p | sed -e 's/Name: //g') 

if [[ -f "$HOME/.zprofile" ]]; then 
	source "$HOME"/.zprofile
else
	style="base" tp="23" bp="23"
fi

# Fix backlight and network modules
fix_modules() {
	# check the graphics card and adjust the backlight module accordingly
	if [[ -z "$graphics_card" ]]; then
		sed -i -e 's/sep backlight/bna/g' 								   		"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
		sed -i -e 's/sep brightness/bna/g' 								   		"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	elif [[ "$graphics_card" != *"intel_"* ]]; then
		sed -i -e 's/backlight/brightness/g' 							   		"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	else
		sed -i -e 's/bna/sep backlight/g' 								   		"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	fi

	# check if bspwm is the curren wm and changes the workspaces module 
	if [[ "$current_desktop" == "bspwm" ]]; then
		bspc config -m focused top_padding "$top_padding"
		bspc config -m focused bottom_padding "$bottom_padding"
		sed -i -e 's/modules-center = workspaces/modules-center = bspwm/g' \
			-i -e 's/override-redirect = .*/override-redirect = true/g' \
			-i -e 's/scroll-up = .*/scroll-up = bspc desktop -f prev.local/g' \
			-i -e 's/scroll-down = .*/scroll-down = bspc desktop -f next.local/g' \
			-i -e 's/titlex\b/title/g' \
			-i -e 's/wm-restack = .*/wm-restack = bspwm/g' 						"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	elif [[ "$current_desktop" == "herbstluftwm" ]]; then
		sed -i -e 's/modules-center = bspwm/modules-center = workspaces/g' \
			-i -e 's/override-redirect = .*/override-redirect = false/g' \
			-i -e 's/titlex\b/title/g' \
			-i -e 's/wm-restack = .*/wm-restack = /g' 						"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	elif [[ "$current_desktop" == "i3" ]]; then
		i3-msg gaps top all set "$top_padding" &> /dev/null
		i3-msg gaps bottom all set "$bottom_padding" &> /dev/null
		sed -i -e 's/modules-center = bspwm/modules-center = workspaces/g' \
			-i -e 's/override-redirect = .*/override-redirect = true/g' \
			-i -e 's/scroll-up = .*/scroll-up = i3-msg workspace prev/g' \
			-i -e 's/scroll-down = .*/scroll-down = i3-msg workspace next/g' \
			-i -e 's/titlex\b/title/g' \
			-i -e 's/wm-restack = .*/wm-restack = i3/g' 						"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	elif [[ "$current_desktop" == "Openbox" ]]; then
		openbox --reconfigure
		sed -i -e 's/modules-center = bspwm/modules-center = workspaces/g' \
			-i -e 's/override-redirect = .*/override-redirect = false/g' \
			-i -e 's/title\b/titlex/g' \
			-i -e 's/wm-restack = .*/wm-restack = /g' 							"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	fi
	if [[ "$(pgrep picom)" ]]; then 
		sed -i -e 's/pseudo-transparency = .*/pseudo-transparency = false/g'	"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	else
		sed -i -e 's/pseudo-transparency = .*/pseudo-transparency = true/g'		"$dir"/config.ini "$dir"/minimal/config-minimal.ini 
	fi

}

## Write values to `system` file
set_values() {
	[[ "$adapter_name" ]] &&
		sed -i -e "s/adapter = .*/adapter = $adapter_name/g"							"$dir"/system.ini
	[[ "$battery_name" ]] &&
		sed -i -e "s/battery = .*/battery = $battery_name/g" 							"$dir"/system.ini
	[[ "$graphics_card" ]] &&
		sed -i -e "s/graphics_card = .*/graphics_card = $graphics_card/g" 				"$dir"/system.ini
	[[ "$network_interface" ]] &&
		sed -i -e "s/network_interface = .*/network_interface = $network_interface/g" 	"$dir"/system.ini
}

# Launch the bar
launch_bar() {
	# Terminate already running bar instances
	killall -q -9 polybar
	# Launch the bar
	if [[ "$bar_style" == "base" ]]; then 
		killall -q -9 updates.sh zscroll playerctl-scroll.sh
		polybar -q top -c "$dir"/config.ini &
		polybar -q bottom -c "$dir"/config.ini &
	elif [[ "$bar_style" == "minimal" ]]; then
		polybar -q main -c "$dir"/minimal/config-minimal.ini &
	fi
}
set_values
fix_modules
launch_bar
