#!/usr/bin/env bash

current_day=$(date +'%m-%d-%Y-%A')
temp_dir_base="$HOME/Pictures/Screenshots/Temp"
temp_dir="$temp_dir_base/$current_day"

if [[ ! -d "$temp_dir" ]]; then
	mkdir -p "$temp_dir"
fi

if ! command -v scrot &> /dev/null || ! command -v grim &> /dev/null ; then
	echo "scrot or grim are not installed!"
	exit 1
fi

if [[ "$(pgrep -f auto-sc.sh | wc -l)" > 2 ]]; then
	echo "Script already running"
	exit 0
fi

while true; do
    new_day=$(date +'%m-%d-%Y-%A')
    if [[ "$new_day" != "$current_day" ]]; then
        current_day="$new_day"
        temp_dir="$temp_dir_base/$current_day"  # Set to the parent directory
        mkdir -p "$temp_dir"
    fi

    time=$(date +%Y-%m-%d-%H%M%S)

    if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
        scrot -q 70 "$temp_dir/$time.png"
    else
        grim "$temp_dir/$time.png"
    fi

    sleep 45
done

