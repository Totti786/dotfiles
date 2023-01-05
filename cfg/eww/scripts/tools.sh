#! /bin/bash

datecover(){
	Wallpapers="$HOME/Pictures/Wallpapers"
	cd $Wallpapers/Wallpapers.git/ &&
	image=$(find -type f -not -path "./.git/*" | shuf -n 1)
	ln -sf $Wallpapers/Wallpapers.git/${image:2} ~/.config/eww/actions/date-cover.jpg
	}
datecover
