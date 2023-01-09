#! /bin/bash

datecover(){
	Wallpapers="$HOME/Pictures/Wallpapers"
	cd $Wallpapers/Wallpapers.git/ &&
	image=$(find -type f -not -path "./.git/*" | shuf -n 1)
	convert $Wallpapers/Wallpapers.git/${image:2} -quality 30 ~/.cache/eww/cover.jpg &&
	ln -sf ~/.cache/eww/cover.jpg ~/.config/eww/controls/date-cover.jpg
	}
datecover
eww reload
