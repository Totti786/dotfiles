#!/usr/bin/env bash

source "$HOME/.cache/wal/colors.sh"
res="$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d 'x' -f2)"
#wm="$(wmctrl -m | head -n1 | cut -d " " -f2)"
conkyConfig="$HOME/.config/conky/conky-$XDG_CURRENT_DESKTOP.conf"

[[ -f "$HOME/.zprofile" ]] && source "$HOME/.zprofile"
[[ "$bar_style" == "bionic" ]] && alpha="255" || alpha="140"

fixconfig(){
	if [[ "$res" == "1080" ]]; then
		sed -i -e "s/gap_y = .*,/gap_y = 162,/g" \
			-i -e "s/minimum_width = .*,/minimum_width = 330,/g" \
			-i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=10',/g" \
			-i -e "s/font1 = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=15',/g" \
			-i -e "s/font2 = 'JetBrains Mono:bold:size=.*',/font2 = 'JetBrains Mono:bold:size=25',/g" "$conkyConfig"
	elif [[ "$res" == "768" ]]; then 
		sed -i -e "s/gap_y = .*,/gap_y = 70,/g" \
			-i -e "s/minimum_width = .*,/minimum_width = 280,/g" \
			-i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=8',/g" \
			-i -e "s/font1 = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=11',/g" \
			-i -e "s/font2 = 'JetBrains Mono:bold:size=.*',/font2 = 'JetBrains Mono:bold:size=20',/g" "$conkyConfig"
	fi
	sed -i -e "s/own_window_colour = '#.*',/own_window_colour = '$(pastel mix -f 0.6 $color8 $color0 | pastel format hex)',/g" \
		-i -e "s/color0 = '#.*',/color0 = '${color9}',/g" \
		-i -e "s/color1 = '#.*',/color1 = '${foreground}',/g" \
		-i -e "s/color2 = '#.*',/color2 = '${color12}',/g" \
		-i -e "s/color3 = '#.*',/color3 = '${color11}',/g" \
		-i -e "s/own_window_argb_value = .*/own_window_argb_value = $alpha,/g" \
	"$conkyConfig"	
	}


toggle(){
	if [ -z "$(pgrep conky)" ]; then 
		fixconfig
		conky -c $conkyConfig &> /dev/null
		[[ "$XDG_CURRENT_DESKTOP" == "bspwm" ]] && xdo lower -N Conky
	else
		pkill conky
	fi
	}

restart(){
	if [ ! -z "$(pgrep conky)" ]; then 
		pkill conky &&
		fixconfig
		conky -c $conkyConfig &> /dev/null
		[[ "$XDG_CURRENT_DESKTOP" == "bspwm" ]] && xdo lower -N Conky
	fi
	}
		
if [[ $1 == "restart" ]]; then restart ;else toggle ;fi
