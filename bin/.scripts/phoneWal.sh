#!/bin/bash

. "$HOME/.cache/wal/colors.sh"

## Send a signal to phone to change wallpaper (requires automate to be set up)
main(){
if command -v kdeconnect-cli &> /dev/null; then
	deviceID="$(kdeconnect-cli -a --id-only)"
	if [[ ! -z $deviceID ]]; then
		cp "$wallpaper" /tmp/wallpaper.jpg
		kdeconnect-cli -d $deviceID --share /tmp/wallpaper.jpg && 
		kdeconnect-cli -d $deviceID --ping
	fi
	exit
else
	echo "KDE Connect is not installed"
fi
}
main &> /dev/null
