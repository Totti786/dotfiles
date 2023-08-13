#!/usr/bin/env bash

config="$HOME/.config/conky/conky-$XDG_CURRENT_DESKTOP.conf"

[[ -f "$HOME/.zprofile" ]] && source "$HOME/.zprofile"
[[ "$bar_style" == "bionic" ]] && alpha="255" || alpha="150"

if [[ -f "$HOME/.cache/wal/colors.sh" ]]; then
	source "$HOME/.cache/wal/colors.sh"
else
	FG="#FFFFFF"
	red="#7ba5dd"
	blue="#ee6a70"
	yellow="#7ba5dd"
	green="#7ba5dd"
	magenta="#ee6a70"
fi


#sed -i -e "s/gap_y = .*,/gap_y = 162,/g" \
	#-i -e "s/minimum_width = .*,/minimum_width = 330,/g" \
	#-i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=10',/g" \
	#-i -e "s/font1 = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=15',/g" \
	#-i -e "s/font2 = 'JetBrains Mono:bold:size=.*',/font2 = 'JetBrains Mono:bold:size=25',/g" \
#"$conkyConfig"

sed -i -e "s/own_window_colour = '.*',/own_window_colour = '$(pastel mix -f 0.4 $color8 $color0 | pastel format hex)',/g" \
	-i -e "s/color0 = '.*',/color0 = '${color10}',/g" \
	-i -e "s/color1 = '.*',/color1 = '${foreground}',/g" \
	-i -e "s/color2 = '.*',/color2 = '${color13}',/g" \
	-i -e "s/color3 = '.*',/color3 = '${color14}',/g" \
	-i -e "s/own_window_argb_value = .*/own_window_argb_value = $alpha,/g" \
"$config"	



toggle(){
	if [[ -z "$(pgrep conky)" ]]; then 
		conky -qc "$config"
		[[ "$XDG_CURRENT_DESKTOP" == "bspwm" ]] && xdo lower -N Conky
	else
		pkill -9 conky
	fi
}

restart(){
	if [[ -n "$(pgrep conky)" ]]; then 
		toggle
		conky -qc "$config"
		[[ "$XDG_CURRENT_DESKTOP" == "bspwm" ]] && xdo lower -N Conky
	fi
}
		
if [[ "$1" == "restart" ]]; then restart ;else toggle ;fi
