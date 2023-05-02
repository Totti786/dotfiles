#!/usr/bin/env bash

dots="$HOME/dotfiles"
rofi_command="rofi -theme ~/.config/rofi/themes/layouts.rasi"

# Variable passed to rofi
options="Update System\nUpdate Configs\nUpdate Wallpapers\nExit"

chosen="$(echo -e "$options" | $rofi_command -p 'Update Menu' -dmenu -selected-row 0)"
case $chosen in
    Update\ System)
		alacritty --class 'alacritty-float,alacritty-float' --hold -e bash -c 'sudo pacman -Syu && dunstify --appname=pacman "Update Successful" && cat > ~/.cache/pacman-updates'
        ;;
    Update\ Configs)
   		cd $dots
		alacritty --class 'alacritty-float,alacritty-float' -e sh $dots/install.sh --update &&
		## remove already existing json file for background color scheme
		rm ~/.config/wpg/schemes/_home_$(whoami)_dotfiles_deps_background_jpg_dark_wal__1.1.0.json
		## change wallpaper and update color scheme 
		sh $dots/bin/.local/bin/wpgtk wall $dots/deps/background.jpg 
        ;;
    Update\ Wallpapers)
		cd $dots
		alacritty --class 'alacritty-float,alacritty-float' -e sh $HOME/dotfiles/install.sh --wallpapers
        ;;
    Exit)
		exit
        ;;
esac

