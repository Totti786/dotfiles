#!/usr/bin/env bash

get_state(){
	state=$(gdbus call \
		--session \
		--dest org.clight.clight \
        --object-path /org/clight/clight \
        --method org.freedesktop.DBus.Properties.Get \
        org.clight.clight $1)

	if [[ "$state" =~ "true" ]]; then
		echo "true"
	else
		echo "false"
	fi
}

toggle_inhibit() {
	# Determine the new state
	if [[ "$(get_state Inhibited)" =~ "true" ]]; then
	    new_state="false"
	else
	    new_state="true"	    
	fi
	
	# Toggle the inhibition
	gdbus call --session \
	           --dest org.clight.clight \
	           --object-path /org/clight/clight \
	           --method org.clight.clight.Inhibit \
	           "$new_state"
}

toggle_pause() {
	# Determine the new state
	if [[ "$(get_state Suspended)" =~ "true" ]]; then
		[[ $(pidof polybar) ]] && polybar-msg action "#autobr.hook.0"
	    new_state="false"
	else
	    [[ $(pidof polybar) ]] && polybar-msg action "#autobr.hook.1"
	    new_state="true"	    
	fi

	# Toggle the inhibition
	gdbus call --session \
	           --dest org.clight.clight \
	           --object-path /org/clight/clight \
	           --method org.clight.clight.Pause \
	           "$new_state"
}


increase_brightness() {           
	gdbus call --session \
	           --dest org.clight.clight \
	           --object-path /org/clight/clight \
	           --method org.clight.clight.IncBl "0.05"
}

decrease_brightness() {           
	gdbus call --session \
	           --dest org.clight.clight \
	           --object-path /org/clight/clight \
	           --method org.clight.clight.DecBl "0.05"
}

capture(){
	gdbus call --session \
	           --dest org.clight.clight \
	           --object-path /org/clight/clight \
	           --method org.clight.clight.Capture \
	           "true" "false"	
}


if [[ -z "$(pgrep clight)" ]]; then
	echo "[!] Clight Not Running"
	exit 0
fi

# Command-line argument handling
case "$1" in
    "--inhibit-status")
		get_state Inhibited
    ;;
    "--pause-status")
		get_state Suspended
    ;;
    "--toggle-inhibit")
		toggle_inhibit
    ;;
    "--toggle-pause")
		toggle_pause
    ;;
	"--increase")
    	increase_brightness
    ;;
	"--decrease")
    	decrease_brightness
    ;;
	"--capture")
    	capture
esac
