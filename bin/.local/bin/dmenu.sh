#!/bin/sh

# Import the colors
. "${HOME}/.cache/wal/colors.sh"

if [[ "$1" ]]; then 
	dmenu -i -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"
else
	dmenu_run -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"
fi
