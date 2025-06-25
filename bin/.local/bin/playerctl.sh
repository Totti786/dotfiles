#!/usr/bin/env bash

## Description: 
# This script interacts with media players using playerctl to fetch and display metadata 
# such as the current track, artist, album, and cover art. 
# It also updates Polybar with media player statuses and icons. 
# The script supports commands to retrieve player status, metadata, 
# cover art, and player names, and to interact with Polybar for displaying media information.

## Dependencies:
# - `playerctl` for interacting with media players and retrieving metadata
# - `imagemagick (magick)` for image processing and generating cover art
# - `curl` for downloading cover art from URLs
# - `xorg-xrdb` to query color settings from the X resource database (optional)
# - `polybar` for displaying media player information on the status bar (optional)
# - `zscroll` for scrolling text in Polybar (optional)

# Get the status of the media player using playerctl
playerctl_status=$(playerctl status 2>&1)

# Function to check if Polybar is running and update it with a specific hook
polybar_update_hooks(){
	# Exit if Polybar is not running
	if [[ -z "$(pgrep polybar)" ]]; then exit 0 ;fi
	
	# Get the ID of the Polybar process matching the given parent bar
	parent_bar_id=$(pgrep -a "polybar" | grep "$parent_bar" | awk '{print $1}')

    # Send the update hook to Polybar
    while IFS= read -r id ;do
        polybar-msg -p "$id" hook playerctl-playpause "$1" > /dev/null 2>&1
    done <<< "$parent_bar_id"
}

# Function to retrieve metadata using playerctl with the format passed as $1
metadata(){
	playerctl metadata --format "$1" 2>/dev/null
}

# Function to get the icon of the currently active media player
player_icon() {
    # Exit if no players are found
    [[ "$playerctl_status" == "No players found" ]] && exit 0

    # Get the name of the active player
    player_name="$(playerctl -l | head -n1 | cut -f1 -d ".")"

    # Define icons for specific players
    declare -A player_icons=(
        ["spotify"]="󰓇"
        ["firefox"]="󰈹"
        ["kdeconnect"]=""
        ["vlc"]="󰕼"
        ["mpv"]=""
        ["rhythmbox"]="󰓃"
        ["chromium"]=""
        ["Gapless"]=""
        ["plasma-browser-integration"]="󰈹"
    )

    # Get the icon for the active player or fallback icon
    player_icon="${player_icons[$player_name]:-"󰎇"}"
}

# Function to get the name and icon of the currently active media player
player_name() {
    # Exit if no players are found
    [[ "$playerctl_status" == "No players found" ]] && exit 0

    # Get the name of the active player
    player_name="$(playerctl -l | head -n1 | cut -f1 -d ".")"

    # Handle special cases for specific players
    case "$player_name" in
        "mpv") friendly_name="mpv" ;;
        "plasma-browser-integration") friendly_name="Firefox" ;;
        "kdeconnect") friendly_name="Phone" ;;
        *) 
            # Capitalize the first letter of the player name for general cases
            friendly_name="${player_name^}"
            ;;
    esac

    # Get the icon by calling the player_icon function
    player_icon

    # Combine friendly name and icon into a single variable
    player_name="$friendly_name $player_icon"
}

# Function to display current playing information and player icon
player(){
	# Set the format for displaying information, checking if artist metadata is available
	if [[ -z $(playerctl metadata --format "{{ artist }}") ]] 2>/dev/null; then
		format="{{ title }}"
	else
		format="{{ title }}: {{ artist }}"
	fi

	player_icon
	current="$(metadata "$format")"
	echo "$current" "${icon:-}"
}

# Function to retrieve and display the cover art of the currently playing track
cover_art(){
	# Retrieve the artwork URL
	url=$(metadata "{{ mpris:artUrl }}")
	fallback_cover="/tmp/cover"
	player_file="/tmp/player"

	cache_dir="$HOME/.cache/playerctl"
	mkdir -p "$cache_dir"
	filename="${url##*/}"
	cover="$cache_dir/${filename%.*}"

	# Remove fallback cover if no players are found
	if [[ "$playerctl_status" == "No players found" ]]; then
	    [[ -f "$fallback_cover" ]] && rm "$fallback_cover" "$player_file"
	else
		# Create a fallback cover image with a colored background and icon
		player_icon
		if [[ "$player_name" != "$(cat $player_file)" ]]; then
			echo "$player_name" > "$player_file"
		    eval $(xrdb -query | awk '/color0/{print "color0="$NF} /color7/{print "color7="$NF}')
		    magick -size 128x128 xc:"$color0" png:"$fallback_cover"
		    magick "$fallback_cover" -gravity center -fill "$color7" \
		    -font '/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf' \
		    -pointsize 60 -annotate 0 "$player_icon" "$fallback_cover"
		fi
	fi

	# Check if the URL is empty
	if [[ -n "$url" ]]; then
	    # Remove 'file://' prefix if present
	    if [[ "$url" == file://* ]]; then
	        cover=${url#file://}
	    # Process the URL if it starts with 'http' or 'https'
		elif [[ "$url" == http://* || "$url" == https://* ]]; then
	        # Download the file only if it does not exist
	        if [[ ! -f "$cover" ]]; then
	            curl -s "$url" > "$cover"
	        fi
	    fi
        echo "$cover"
	fi
}

# Handle script arguments to perform specific actions
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
        echo "$player_name"
        ;;
    "--icon")
        player_icon
        echo "$player_icon"
        ;;
    "--polybar" | "--polybar-minimal")
        case "$playerctl_status" in
            "Stopped")
                echo "No music is playing"
                ;;
            "Paused")
				if [ -n "$($0 --title)" ]; then
					polybar_update_hooks 2
					player
                fi
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
		command -v zscroll >/dev/null || echo '[!] zscroll is not installed'
		# zscroll is used to scroll text in Polybar
		zscroll -l 50 \
	        --delay 0.7 \
	        --scroll-padding " " \
	        --match-command "$0 --status" \
	        --match-text "Playing" "--scroll 1" \
	        --match-text "Paused" "--scroll 0" \
	        --update-check true "$0 --polybar" &
		wait
        ;;
    *)
		echo "${0##*/}: invalid option $1"
    ;;
esac
