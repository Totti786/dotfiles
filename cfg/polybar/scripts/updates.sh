#!/bin/bash

while true; do
	if [[ $(date +%M) == "01" ]]; then
		$(checkupdates  > ~/.cache/pacman-updates)
	fi 
	
	updateCount=$(cat ~/.cache/pacman-updates | wc -l)
	
	if [[ $updateCount == "0" ]]; then 
		echo " None"
		sleep 45
	else 
		echo " $updateCount"
		sleep 45
	fi
done
