#!/usr/bin/env bash

dots="$HOME/dotfiles"
rofi_command="rofi -theme $dots/cfg/rofi/themes/screenshot.rasi"

# Variable passed to rofi
options="Update\nExit"

chosen="$(echo -e "$options" | $rofi_command -p 'Update Menu' -dmenu -selected-row 0)"
case $chosen in
    Update)
		cd $dots
		"$dots"/cfg/rofi/bin/apps_as_root.sh "alacritty -e sh $HOME/dotfiles/install.sh --update"
        ;;
    Exit)
		Exit
        ;;
esac

