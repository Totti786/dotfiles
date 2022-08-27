#!/usr/bin/env bash

## Autostart Programs

## Kill already running process
_ps=(picom dunst ksuperkey mpd xfce-polkit xfce4-power-manager polybar trackma-gtk)
for _prs in "${_ps[@]}"; do
	if [[ `pidof ${_prs}` ]]; then
		killall -9 ${_prs}
	fi
done

## Fix cursor
xsetroot -cursor_name left_ptr

## Polkit agent
/usr/lib/xfce-polkit/xfce-polkit &

## Dunst
dunst &

## Picom	
picom --experimental-backends &

## Restore Wallpaper
exec wal -Re &

# Enable power management
xfce4-power-manager &

# Enable Super Keys For Menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

## Restore Wallpaper
#nitrogen --restore

## Launch Polybar
exec sh ~/.config/polybar/launch.sh &

## Excute Screenshot script
exec sh ~/.scripts/check.sh &

## Thunar Daemon
exec thunar --daemon &

## Touchegg
exec touchegg --daemon &
exec touchegg &

## Discord Launch
exec discord &

## Trackma Launch
exec trackma-gtk &

## KDE Conenct
exec kdeconnect-indicator &

## CopyQ
exec copyq &
