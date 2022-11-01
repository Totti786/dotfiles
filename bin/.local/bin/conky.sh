#!/bin/bash

res="$(xrandr -q | grep "current" | cut -d "," -f2 | cut -d " " -f5)"
wm="$(wmctrl -m |sed -n 1p | sed -e 's/Name: //g')"
conkyConfig=$HOME/.config/conky/conky-"$wm"-"$res".conf

if [ -z "$(pgrep conky)" ]; then 
	conky -c $conkyConfig &> /dev/null
else
	pkill conky
fi
