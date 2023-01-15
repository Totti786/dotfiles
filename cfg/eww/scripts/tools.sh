#! /bin/bash

Wallpapers="$HOME/Pictures/Wallpapers"
cd $Wallpapers/Wallpapers.git/ &&
image=$(find -type f -not -path "./.git/*" | shuf -n 1)
cp $Wallpapers/Wallpapers.git/${image:2} ~/.cache/eww/cover.jpg &&
ln -sf ~/.cache/eww/cover.jpg ~/.config/eww/controls/date-cover.jpg

eww reload
