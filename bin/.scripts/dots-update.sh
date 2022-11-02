#!/usr/bin/env bash

dots="$HOME/dotfiles"
rofi_command="rofi -theme $dots/cfg/rofi/themes/window.rasi"

# Variable passed to rofi
options="Update\nExit"

chosen="$(echo -e "$options" | $rofi_command -p 'Update Menu' -dmenu -selected-row 0)"
case $chosen in
    Update)
		cd $dots
		alacritty -e sh $HOME/dotfiles/install.sh --update
        ;;
    Exit)
		exit
        ;;
esac
