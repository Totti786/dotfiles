#!/bin/bash

while true; do
	if [[ "$(date +%M)" == "01" ]]; then
		checkupdates  > "$HOME"/.cache/pacman-updates
	fi 
	
	updateCount="$(< "$HOME"/.cache/pacman-updates | wc -l)"
	
	if [[ "$updateCount" == "0" ]]; then 
		echo " None"
		sleep 45
	else 
		echo " $updateCount"
		sleep 45
	fi
done
