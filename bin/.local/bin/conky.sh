#!/bin/bash

res="$(xrandr -q | grep "current" | cut -d "," -f2 | cut -d " " -f5)"
wm="$(wmctrl -m |sed -n 1p | sed -e 's/Name: //g')"
conkyConfig=$HOME/.config/conky/conky-"$wm".conf

changefont(){
	if [[ "$res" == "1080" ]]; then
		sed -i -e "s/gap_y = .*,/gap_y = 125,/g" $conkyConfig
		sed -i -e "s/minimum_width = .*,/minimum_width = 330,/g" $conkyConfig
		sed -i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=10',/g" $conkyConfig
		sed -i -e "s/font1  = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=13',/g" $conkyConfig
		sed -i -e "s/font2  = 'JetBrains Mono:Bold:size=.*',/font2 = 'JetBrains Mono:bold:size=30',/g" $conkyConfig
	elif [[ "$res" == "768" ]]; then 
		sed -i -e "s/gap_y = .*,/gap_y = 55,/g" $conkyConfig
		sed -i -e "s/minimum_width = .*,/minimum_width = 280,/g" $conkyConfig
		sed -i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=8',/g" $conkyConfig
		sed -i -e "s/font1  = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=11',/g" $conkyConfig
		sed -i -e "s/font2  = 'JetBrains Mono:Bold:size=.*',/font2 = 'JetBrains Mono:bold:size=23',/g" $conkyConfig
	fi
	}


if [ -z "$(pgrep conky)" ]; then 
	changefont
	conky -c $conkyConfig &> /dev/null
else
	pkill conky
fi
