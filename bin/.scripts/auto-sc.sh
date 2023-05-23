#! /bin/bash

DIR="$HOME/Pictures/Screenshots/Temp"
[[ ! -d "$DIR" ]] && mkdir -p "$DIR"

sc(){
	cd "$DIR"
	while true; do
		time=$(date +%Y-%m-%d-%H%M%S)
		if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
			scrot -q 70 "$DIR/$time.png"
		else
			grim "$DIR/$time.png"
		fi
		sleep 45
	done
}

if command -v scrot &> /dev/null || command -v grim &> /dev/null ; then
	if [[ "$(pgrep auto-sc.sh | wc -l)" > 2 ]]; then
		echo "Script already running"
	else
		sc
	fi
fi
