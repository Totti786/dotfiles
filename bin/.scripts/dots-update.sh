#!/usr/bin/env bash

dots="$HOME/dotfiles"
rofi_command="rofi -theme ~/.config/rofi/themes/window.rasi"

# Variable passed to rofi
options="Update System\nUpdate Configs\nExit"

chosen="$(echo -e "$options" | $rofi_command -p 'Update Menu' -dmenu -selected-row 0)"
case $chosen in
    Update\ System)
		furminal --float -e yay
        ;;
    Update\ Configs)
		cd $dots
		alacritty -e sh $HOME/dotfiles/install.sh --update
        ;;
    Exit)
		exit
        ;;
esac

