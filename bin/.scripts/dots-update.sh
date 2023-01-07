#!/usr/bin/env bash

dots="$HOME/dotfiles"
rofi_command="rofi -theme ~/.config/rofi/themes/window.rasi"

# Variable passed to rofi
options="Update System\nUpdate Configs\nUpdate Wallpapers\nExit"

chosen="$(echo -e "$options" | $rofi_command -p 'Update Menu' -dmenu -selected-row 0)"
case $chosen in
    Update\ System)
		alacritty --class 'alacritty-float,alacritty-float' --hold -e bash -c 'sudo pacman -Syu && dunstify --appname=pacman "Update Successful" && cat > ~/.cache/pacman-updates'
        ;;
    Update\ Configs)
		cd $dots
		alacritty --class 'alacritty-float,alacritty-float' -e sh $HOME/dotfiles/install.sh --update
        ;;
    Update\ Wallpapers)
		cd $dots
		alacritty --class 'alacritty-float,alacritty-float' -e sh $HOME/dotfiles/install.sh --wallpapers
        ;;
    Exit)
		exit
        ;;
esac

