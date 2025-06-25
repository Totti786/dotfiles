#!/usr/bin/env bash

# Launchs Polybar from multiple window managers

[[ -f "$HOME/.theme" ]] && source "$HOME/.theme"
[[ -z "$bar_style" ]] && bar_style="base" top_padding="23" bottom_padding="23"

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
graphics_card="$(ls /sys/class/backlight/ | tail -n1)"
network_interface="$(ip link | awk '/state UP/ {print $2}' | tr -d :)"
battery_name=$(ls -1 /sys/class/power_supply/ | grep BA)
adapter_name=$(ls -1 /sys/class/power_supply/ | grep AC)
current_desktop=$(wmctrl -m | head -n1 | cut -d " " -f2) 
config_file="$dir/$bar_style/config.ini"

change_modules(){
	sed -i -e "s/\(workspaces\|bspwm\|i3\)/$1/g" 	\
		-i -e "s/wm-name = .*/wm-name = $2/g" \
		-i -e "s/wm-restack = .*/wm-restack = $2/g" \
		-i -e "s/override-redirect = .*/override-redirect = $3/g" \
	"$config_file"
}

# Fix backlight and network modules
fix_modules() {
	# check the graphics card and adjust the backlight module accordingly
	if [[ -z "$graphics_card" ]]; then
		sed -i -e 's/\(backlight\|brightness\)/bna/g' 			"$config_file"
	elif [[ "$graphics_card" != *"intel_"* ]]; then
		sed -i -e 's/\(backlight\|bna\)/brightness/g' 			"$config_file"
	else
		sed -i -e 's/\(bna\|backlight\)/brightness/g' 			"$config_file"
	fi
	
	# check if the compositor is off and turn on pseudo transparency
	if [[ "$(pgrep picom)" ]] || [[ $(pgrep compfy) ]]; then 
		sed -i -e 's/pseudo-transparency = .*/pseudo-transparency = false/g' "$config_file"
	else
		sed -i -e 's/pseudo-transparency = .*/pseudo-transparency = true/g'	 "$config_file"
	fi
	
	# check if bspwm is the curren wm and changes the workspaces module 
	case "$current_desktop" in
	 "Openbox")
		sed -i -e 's/title\b/titlex/g' "$config_file"
		change_modules "workspaces" "openbox" "false"
	 	;;
	 "bspwm")
		bspc config -m focused top_padding "$top_padding"
		bspc config -m focused bottom_padding "$bottom_padding"
		sed -i -e 's/titlex\b/title/g' "$config_file"
		change_modules "bspwm" "bspwm" "true"
		;;
	 "i3")
		"$HOME"/.config/i3/i3-reload
		sed -i -e 's/titlex\b/title/g' "$config_file"			
		change_modules "i3" "i3" "true"
		;;
	 "herbstluftwm")
		sed -i -e 's/titlex\b/title/g' "$config_file"
		change_modules "workspaces" "herbstluftwm" "false"
		;;	
	 *)	 	 
		echo "Unknown window manager: $current_desktop"
		;;
	esac
}

# Write values to `system` file
set_values() {
	[[ "$adapter_name" ]] &&
		sed -i -e "s/adapter = .*/adapter = $adapter_name/g"							"$dir/system.ini"
	[[ "$battery_name" ]] &&
		sed -i -e "s/battery = .*/battery = $battery_name/g" 							"$dir/system.ini"
	[[ "$graphics_card" ]] &&
		sed -i -e "s/graphics_card = .*/graphics_card = $graphics_card/g" 				"$dir/system.ini"
	[[ "$network_interface" ]] &&
		sed -i -e "s/network_interface = .*/network_interface = $network_interface/g" 	"$dir/system.ini"
}

tray_reload(){
	[[ $(pgrep stalonetray) ]] && pkill stalonetray && "$dir"/scripts/systray
	"$dir"/scripts/systray
	}

check_recording(){
	if [[ "$(recorder --status)"  == "on" ]]; then 
		polybar-msg action "#recorder.hook.1"
	elif [[ "$(recorder --status)"  == "paused" ]]; then 
		polybar-msg action "#recorder.hook.2"
	fi
}

check_clight(){
	if [[ "$(clight.sh --pause-status)" == "false" ]]; then
	    [[ $(pidof polybar) ]] && polybar-msg action "#autobr.hook.0"
	else
		[[ $(pidof polybar) ]] && polybar-msg action "#autobr.hook.1"
	fi
}

# Launch the bar
launch_bar() {
	# Terminate already running bar instances
	killall -q -9 polybar
	# Launch the bar
	if [[ "$bar_style" == "base" ]]; then 
		killall -q -9 updates.sh zscroll playerctl-scroll.sh
		polybar -q top -c "$config_file" &
		polybar -q main -c "$config_file" &
	else
		polybar -q main -c "$config_file" &
	fi
}

set_values
fix_modules
launch_bar &&
check_clight
check_recording
tray_reload
