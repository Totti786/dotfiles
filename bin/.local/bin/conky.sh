#!/bin/bash

source "$HOME/.cache/wal/colors.sh"
res="$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d 'x' -f2)"
wm="$(wmctrl -m |sed -n 1p | sed -e 's/Name: //g' | cut -d " " -f1)"
conkyConfig="$HOME/.config/conky/conky-$wm.conf"

fixconfig(){
	if [[ "$res" == "1080" ]]; then
		sed -i -e "s/gap_y = .*,/gap_y = 140,/g" \
			-i -e "s/minimum_width = .*,/minimum_width = 330,/g" \
			-i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=10',/g" \
			-i -e "s/font1 = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=15',/g" \
			-i -e "s/font2 = 'JetBrains Mono:bold:size=.*',/font2 = 'JetBrains Mono:bold:size=25',/g" "$conkyConfig"
	elif [[ "$res" == "768" ]]; then 
		sed -i -e "s/gap_y = .*,/gap_y = 50,/g" \
			-i -e "s/minimum_width = .*,/minimum_width = 280,/g" \
			-i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=8',/g" \
			-i -e "s/font1 = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=11',/g" \
			-i -e "s/font2 = 'JetBrains Mono:bold:size=.*',/font2 = 'JetBrains Mono:bold:size=20',/g" "$conkyConfig"
	fi
	sed -i -e "s/own_window_colour = '#.*',/own_window_colour = '${background}',/g" \
		-i -e "s/color0 = '#.*',/color0 = '${color9}',/g" \
		-i -e "s/color1 = '#.*',/color1 = '${foreground}',/g" \
		-i -e "s/color2 = '#.*',/color2 = '${color12}',/g" \
		-i -e "s/color3 = '#.*',/color3 = '${color11}',/g" "$conkyConfig"	
	}


toggle(){
	if [ -z "$(pgrep conky)" ]; then 
		fixconfig
		conky -c $conkyConfig &> /dev/null
		[[ "$wm" == "bspwm" ]] && xdo lower -N Conky
	else
		pkill conky
	fi
	}

restart(){
	if [ ! -z "$(pgrep conky)" ]; then 
		pkill conky &&
		fixconfig
		conky -c $conkyConfig &> /dev/null
		[[ "$wm" == "bspwm" ]] && xdo lower -N Conky
	fi
	}
		
if [[ $1 == "restart" ]]; then 	restart ;else toggle ;fi
