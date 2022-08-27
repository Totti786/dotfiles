#!/bin/bash

#changeTray(){
	#if [[ $(grep -i "tray-position = " ~/.config/polybar/config.ini) = "tray-position = right" ]]; then
		#sed -i -e 's/tray-position = right/tray-position = none/g' ~/.config/polybar/config.ini
	#elif [[ $(grep -i "tray-position = " ~/.config/polybar/config.ini) = "tray-position = none" ]]; then
		#sed -i -e 's/tray-position = none/tray-position = right/g' ~/.config/polybar/config.ini
	#fi
#}
#changeTray 
sh ~/.config/polybar/launch.sh
