#!/usr/bin/env bash

config="$HOME/.config/conky/conky-$XDG_CURRENT_DESKTOP.conf"

[[ -f "$HOME/.theme" ]] && source "$HOME/.theme"
[[ "$bar_style" == "bionic" ]] && alpha_conky="255" || alpha_conky="180"

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

sed -i "$config" \
	-e "s/own_window_colour = '.*',/own_window_colour = '$(pastel mix -f 0.4 $color8 $color0 | pastel format hex)',/g" \
	-e "s/color0 = '.*',/color0 = '${color10}',/g" \
	-e "s/color1 = '.*',/color1 = '${foreground}',/g" \
	-e "s/color2 = '.*',/color2 = '${color13}',/g" \
	-e "s/color3 = '.*',/color3 = '${color14}',/g" \
	-e "s/own_window_argb_value = .*/own_window_argb_value = $alpha_conky,/g"

toggle(){
	if [[ -z "$(pgrep conky)" ]]; then 
		conky -qc "$config"
		[[ "$XDG_CURRENT_DESKTOP" == "bspwm" ]] && xdo lower -N Conky
	else
		pkill -9 conky
	fi
}

restart(){
	if [[ "$(pgrep conky)" ]]; then
		[[ -n "$(pgrep conky)" ]] && pkill -9 conky
		conky -qc "$config"
		[[ "$XDG_CURRENT_DESKTOP" == "bspwm" ]] && xdo lower -N Conky
	else
		pkill -9 conky
	fi
}

if [[ "$1" == "restart" ]]; then restart ;else toggle ;fi
