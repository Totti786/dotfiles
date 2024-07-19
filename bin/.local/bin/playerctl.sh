#!/usr/bin/env bash

playerctl_status=$(playerctl status 2>&1)

# Checks if polybar is running and send $1 as a message to polybar
polybar_update_hooks(){
	if [[ -z "$(pgrep polybar)" ]]; then exit 0 ;fi
	
	parent_bar_id=$(pgrep -a "polybar" | grep "$parent_bar" | awk '{print $1}')

    while IFS= read -r id ;do
        polybar-msg -p "$id" hook playerctl-playpause "$1" > /dev/null 2>&1
    done <<< "$parent_bar_id"
}

# Get meta data with paramtere passed as $1
metadata(){
	playerctl metadata --format "$1" 2>/dev/null
}

# 
player_icon(){
	player_name="$(playerctl -l | head -n1 | cut -f1 -d ".")"
	declare -A player_icons=(
		["spotify"]="󰓇"
		["firefox"]="󰈹"
		["kdeconnect"]=""
		["vlc"]="󰕼"
		["mpv"]=""
		["rhythmbox"]="󰓃"
		["chromium"]=""
		["plasma-browser-integration"]="󰈹"
	)
	
	icon="${player_icons[$player_name]}"
}

player_name(){
	player_name="$(playerctl -l | head -n1 | cut -f1 -d ".")"
	declare -A player_icons=(
		["spotify"]="Spotify "
		["firefox"]="Firefox 󰈹"
		["kdeconnect"]="Phone "
		["vlc"]="VLC 󰕼"
		["mpv"]="mpv "
		["rhythmbox"]="Rhythmbox 󰓃"
		["chromium"]="Chromium "
		["plasma-browser-integration"]="Firefox 󰈹"
	)
	
	icon="${player_icons[$player_name]}"
}

player(){
	# Format of the information displayed
	# Eg. {{ artist }} - {{ album }} - {{ title }}
	# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata
	if [[ -z $(playerctl metadata --format "{{ artist }}") ]] 2>/dev/null; then
		format="{{ title }}"
	else
		format="{{ title }}: {{ artist }}"
	fi
		
	player_icon
	current="$(metadata "$format")"
	echo "$current" "${icon:-}"
}

cover_art(){
	# Retrieve the artwork URL
	url=$(metadata "{{ mpris:artUrl }}")
	fallback_cover="/tmp/cover"
	
	if [[ "$playerctl_status" == "No players found" ]]; then
	    [[ -f "$fallback_cover" ]] &&  rm "$fallback_cover"
	else
		# Default case: create an image with a colored background and an icon
	    eval $(xrdb -query | awk '/color0/{print "color0="$NF} /color7/{print "color7="$NF}')
	    magick -size 128x128 xc:"$color0" png:"$fallback_cover"
	    magick "$fallback_cover" -gravity center -fill "$color7" \
	    -font /usr/share/fonts/TTF/SymbolsNerdFont-Regular.ttf \
	    -pointsize 50 -annotate 0 "󰎇" "$fallback_cover"
	fi
	
	
	# Check if the URL is empty
	if [ -n "$url" ]; then
	    # Remove 'file://' prefix if present
	    if [[ "$url" == file://* ]]; then
	        url=${url#file://}
	        if [[ $(file --extension "$url" | awk '{print $2}') != "png" ]]; then
	            magick "$url" -resize 128x128 png:"$url"
	        fi
	        echo "$url"
	    fi
	
	    # Process the URL if it starts with 'http' or 'https'
	    if [[ "$url" == http://* || "$url" == https://* ]]; then
	        cache_dir="$HOME/.cache/playerctl"
	        mkdir -p "$cache_dir"
	        filename=$(basename "$url")
	        destination="$cache_dir/$filename"
	
	        # Download the file only if it does not exist
	        if [ ! -f "$destination" ]; then
	            curl -s "$url" | magick - -resize 128x128 png:"$destination"
	        fi
	        echo "$destination"
	    fi
	fi
}


case "$1" in
    "--status")
        echo "$playerctl_status"
        ;;
    "--title")
        title=$(metadata "{{ title }}")
        echo ${title:0:28}
        ;;
    "--artist")
        artist=$(metadata "{{ artist }}")
        echo ${artist:0:27}
        ;;
    "--album")
        metadata "{{ album }}"
        ;;
    "--duration")
        metadata "{{ duration(position) }} / {{ duration(mpris:length) }}"
        ;;
    "--art")
		cover_art
        ;;
    "--player")
        player_name
        echo "$icon"
        ;;
    "--icon")
        player_icon
        echo "$icon"
        ;;
    "--polybar" | "--polybar-minimal")
        case "$playerctl_status" in
            "Stopped")
                echo "No music is playing"
                ;;
            "Paused")
                polybar_update_hooks 2
                player
                ;;
            "No players found")
                if [ "$1" = "--polybar-minimal" ]; then
                    echo ""
                    polybar_update_hooks 3
                else
                    echo "Doesn't look like anything to me"
                fi
                ;;
            *)
                polybar_update_hooks 1
                player
                ;;
        esac
        ;;
    "--scroll")
		zscroll -l 50 \
	        --delay 0.7 \
	        --scroll-padding " " \
	        --match-command "$0 --status" \
	        --match-text "Playing" "--scroll 1" \
	        --match-text "Paused" "--scroll 0" \
	        --update-check true "$0 --polybar" &
		wait
        ;;
esac
