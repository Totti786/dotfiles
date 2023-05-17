#!/usr/bin/env bash

rofi_command="rofi -theme $HOME/.config/rofi/themes/layouts.rasi"
dots="$HOME/.dotfiles"

if [ ! -d "$HOME/.dotfiles" ]; then 
	mkdir "$dots"
	furminal --float -e bash -c 'git clone --depth 1 https://github.com/totti786/dotfiles.git ~/.dotfiles'
fi

cd "$dots"
if [[ "$(git rev-parse --is-inside-work-tree)" != "true" ]]; then 
	rm -R "$dots" && notify-send -r 34 'Cloning Failed' 
	exit 1
fi

# Variable passed to rofi
options="Update System\nUpdate Configs\nUpdate Wallpapers\nExit"

chosen="$(echo -e "$options" | $rofi_command -p 'Update Menu' -dmenu -selected-row 0)"
case $chosen in
    "Update System")
		furminal --float -e bash -c 'sudo pacman -Syu && dunstify --appname=pacman "Update Successful" && cat > ~/.cache/pacman-updates'
        ;;
    "Update Configs")
   		cd "$dots"
		furminal --float -e sh "$dots"/install.sh --update &&
		## remove already existing json file for background color scheme
		wpg -R "$dots"/deps/background.jpg 
		## change wallpaper and update color scheme 
		"$dots"/bin/.local/bin/wpgtk wall "$dots"/deps/background.jpg 
        ;;
    "Update Wallpapers")
		cd "$dots"
		furminal --float -e sh "$dots"/install.sh --wallpapers
        ;;
    "Exit")
		exit
        ;;
esac

