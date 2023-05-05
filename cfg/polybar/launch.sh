#!/usr/bin/env bash

# Launchs Polybar from multiple window managers


dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
graphics_card="$(light -L | grep -m1 'backlight' | cut -d'/' -f3)"
network_interface="$(ip link | awk '/state UP/ {print $2}' | tr -d :)"
battery_name=$(upower -i "$(upower -e | grep 'BAT')" | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
adapter_name=$(upower -i "$(upower -e | grep 'AC')" | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
current_desktop=$(wmctrl -m | head -n1 | cut -d " " -f2) 
config_file="$dir/config.ini"
minimal_config_file="$dir/minimal/config-minimal.ini"



if [[ -f "$HOME/.zprofile" ]]; then 
	source "$HOME/.zprofile"
else
	bar_style="base"
	top_padding="23"
	bottom_padding="23"
fi

# Fix backlight and network modules
fix_modules() {
	# check the graphics card and adjust the backlight module accordingly
	if [[ -z "$graphics_card" ]]; then
		sed -i -e 's/sep backlight/bna/g' 								   		"$config_file" "$minimal_config_file"
		sed -i -e 's/sep brightness/bna/g' 								   		"$config_file" "$minimal_config_file"
	elif [[ "$graphics_card" != *"intel_"* ]]; then
		sed -i -e 's/backlight/brightness/g' 							   		"$config_file" "$minimal_config_file"
	else
		sed -i -e 's/bna/sep backlight/g' 								   		"$config_file" "$minimal_config_file"
	fi

	# check if bspwm is the curren wm and changes the workspaces module 
	case "$current_desktop" in
	 "bspwm")
		bspc config -m focused top_padding "$top_padding"
		bspc config -m focused bottom_padding "$bottom_padding"
		sed -i -e 's/modules-center = \(i3\|workspaces\)/modules-center = bspwm/g'  \
			-i -e 's/override-redirect = .*/override-redirect = true/g' 			\
			-i -e 's/scroll-up = .*/scroll-up = bspc desktop -f prev.local/g' 		\
			-i -e 's/scroll-down = .*/scroll-down = bspc desktop -f next.local/g' 	\
			-i -e 's/titlex\b/title/g'												\
			-i -e 's/ssep/systray/g'												\
			-i -e 's/tray-position = .*/tray-position = none/g'						\
			-i -e 's/wm-restack = .*/wm-restack = bspwm/g' 							"$config_file" "$minimal_config_file"
		;;
	 "herbstluftwm")
		sed -i -e 's/modules-center = \(i3\|bspwm\)/modules-center = workspaces/g' 	\
			-i -e 's/override-redirect = .*/override-redirect = false/g' 			\
			-i -e 's/titlex\b/title/g' 												\
			-i -e 's/ssep/systray/g' 												\
			-i -e 's/tray-position = .*/tray-position = none/g'						\
			-i -e 's/wm-restack = .*/wm-restack = /g' 								"$config_file" "$minimal_config_file"
		;;	
	 "i3")
		i3-msg gaps top all set "$top_padding" &> /dev/null
		i3-msg gaps bottom all set "$bottom_padding" &> /dev/null
		sed -i -e 's/modules-center = \(bspwm\|workspaces\)/modules-center = i3/g' 	\
			-i -e 's/override-redirect = .*/override-redirect = true/g' 			\
			-i -e 's/scroll-up = .*/scroll-up = ~\/.config\/i3\/i3-workspaces prev/g' \
			-i -e 's/scroll-down = .*/scroll-down = ~\/.config\/i3\/i3-workspaces next/g' \
			-i -e 's/titlex\b/title/g' 												\
			-i -e 's/systray/ssep/g'												\
			-i -e 's/tray-position = .*/tray-position = right/g'					\
			-i -e 's/wm-restack = .*/wm-restack = i3/g' 							"$config_file" "$minimal_config_file"
		;;	
	 "Openbox")
		openbox --reconfigure
		sed -i -e 's/modules-center = \(i3\|bspwm\)/modules-center = workspaces/g'	\
			-i -e 's/override-redirect = .*/override-redirect = false/g'			\
			-i -e 's/title\b/titlex/g' 												\
			-i -e 's/ssep/systray/g' 												\
			-i -e 's/tray-position = .*/tray-position = none/g'						\
			-i -e 's/wm-restack = .*/wm-restack = /g' 								"$config_file" "$minimal_config_file"
	 	;;
	 	
	 *)	 	 
		echo "Unknown window manager: $current_desktop"
		;;
	esac
	if [[ "$(pgrep picom)" ]]; then 
		sed -i -e 's/pseudo-transparency = .*/pseudo-transparency = false/g'		"$config_file" "$minimal_config_file"
	else
		sed -i -e 's/pseudo-transparency = .*/pseudo-transparency = true/g'			"$config_file" "$minimal_config_file"
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
