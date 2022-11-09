#!/bin/bash

while true; do
	if [[ $(date +%M) == "00" ]]; then
		$(checkupdates  > ~/.cache/pacman-updates)
	fi 
	
	updateCount=$(cat ~/.cache/pacman-updates | wc -l)
	
	if [[ $updateCount == "0" ]]; then 
		echo " None"
		sleep 120
	else 
		echo " $updateCount"
		sleep 60
	fi
done


