#!/bin/bash

version="$(pacman -Q discord | cut -d " " -f2 | cut -d "-" -f1)"
dir="$HOME/.config/discord/$version/modules/discord_desktop_core/"

main(){
	cd $dir && npx asar extract core.asar core
	sed -i -e 's/function setTrayIcon(icon) {/function setTrayIcon(icon) {\nreturn;/g' ~/.config/discord/$version/modules/discord_desktop_core/core/app/systemTray.js
	sed -i -e 's/core.asar/core/g' ~/.config/discord/$version/modules/discord_desktop_core/index.js
}

if command -v npm; then 
	main
else
	sudo pacman -S npm &&
	main
fi 
