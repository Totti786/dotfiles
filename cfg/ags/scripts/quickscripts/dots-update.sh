#!/usr/bin/env bash

# Variables and functions
dots="$HOME/.dotfiles"

if [[ ! -d "$dots" ]]; then 
	mkdir "$dots"
	git clone --depth 1 https://github.com/totti786/dotfiles.git "$dots"

	cd "$dots"
	if [[ "$(git rev-parse --is-inside-work-tree)" != "true" ]]; then 
		rm -r "$dots" && notify-send -r 34 'Cloning Failed' 
		exit 1
	fi
else
	#cd "$dots"
	#"$dots"/install.sh --update &&
	## remove already existing json file for background color scheme
	rm "$HOME/.config/wpg/schemes/_home_$(whoami)__dotfiles_deps_background_jpg_dark_wal__1.1.0.json"
	## change wallpaper and update color scheme
	"$dots"/bin/.local/bin/wpgtk wall "$dots"/deps/background.jpg
	tput -x clear
	echo "Update is complete!"
	echo "You can now close this window"
fi
