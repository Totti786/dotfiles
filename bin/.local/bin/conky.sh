#!/bin/bash

res="$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d 'x' -f2)"
wm="$(wmctrl -m |sed -n 1p | sed -e 's/Name: //g')"
conkyConfig=$HOME/.config/conky/conky-"$wm".conf

changefont(){
	if [[ "$res" == "1080" ]]; then
		sed -i -e "s/gap_y = .*,/gap_y = 140,/g" $conkyConfig
		sed -i -e "s/minimum_width = .*,/minimum_width = 330,/g" $conkyConfig
		sed -i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=10',/g" $conkyConfig
		sed -i -e "s/font1 = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=15',/g" $conkyConfig
		sed -i -e "s/font2 = 'JetBrains Mono:bold:size=.*',/font2 = 'JetBrains Mono:bold:size=25',/g" $conkyConfig
	elif [[ "$res" == "768" ]]; then 
		sed -i -e "s/gap_y = .*,/gap_y = 50,/g" $conkyConfig
		sed -i -e "s/minimum_width = .*,/minimum_width = 280,/g" $conkyConfig
		sed -i -e "s/font  = 'JetBrains Mono:Bold:size=.*',/font  = 'JetBrains Mono:Bold:size=8',/g" $conkyConfig
		sed -i -e "s/font1 = 'JetBrains Mono:Bold:size=.*',/font1 = 'JetBrains Mono:Bold:size=11',/g" $conkyConfig
		sed -i -e "s/font2 = 'JetBrains Mono:bold:size=.*',/font2 = 'JetBrains Mono:bold:size=20',/g" $conkyConfig
	fi
	}

toggle(){
	if [ -z "$(pgrep conky)" ]; then 
		changefont
		conky -c $conkyConfig &> /dev/null
		xdo lower -N Conky
	else
		pkill conky
	fi
	}

restart(){
	pkill conky &&
	changefont
	conky -c $conkyConfig &> /dev/null
	xdo lower -N Conky
	}
		
if [[ $1 == "restart" ]]; then 
	restart
else
	toggle
fi
