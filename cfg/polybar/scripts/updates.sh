#!/bin/bash

while true; do
	if [[ "$(date +%M)" == "01" ]]; then
		checkupdates  > "$HOME"/.cache/pacman-updates
	fi 
	
	update_count="$(< "$HOME"/.cache/pacman-updates | wc -l)"
	
	if [[ "$update_count" == "0" ]]; then 
		echo " None"
		sleep 45
	else 
		echo " $update_count"
		sleep 45
	fi
done
