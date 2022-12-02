#!/usr/bin/env bash

dots="$HOME/dotfiles"
rofi_command="rofi -theme ~/.config/rofi/themes/window.rasi"

# Variable passed to rofi
options="Update System\nUpdate Configs\nExit"


sysUpdate(){
	up=$()
	alacritty --class 'alacritty-float,alacritty-float' -e bash -c 'sudo pacman -Syyu && rm ~/.cache/pacman-updates && echo "Update Successful" && sleep 3'
	}


chosen="$(echo -e "$options" | $rofi_command -p 'Update Menu' -dmenu -selected-row 0)"
case $chosen in
    Update\ System)
		sysUpdate
        ;;
    Update\ Configs)
		cd $dots
		alacritty --class 'alacritty-float,alacritty-float' -e sh $HOME/dotfiles/install.sh --update
        ;;
    Exit)
		exit
        ;;
esac

