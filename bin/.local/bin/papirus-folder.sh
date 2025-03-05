#!/usr/bin/env bash

# Dependencies: `xfconf-query` `sed` `gsettings (optional)`

# This function takes a hexadecimal color value and a light delta, and returns a darker color value.
darker_channel() {
	local value="0x$1"
	local light_delta="0x$2"
	local -i result

	result=$(( value - light_delta ))

	# Ensure that the result is within the range 0-255.
	(( result < 0   )) && result=0
	(( result > 255 )) && result=255

	echo "$result"
}

# This function takes a hexadecimal color value and a light delta, and returns a darker color value in hexadecimal format.
# The light delta is an optional argument that defaults to 10 if not provided.
darker() {
	local hexinput="$1"
	local light_delta=${2-10}

	r=$(darker_channel "${hexinput:0:2}" "$light_delta")
	g=$(darker_channel "${hexinput:2:2}" "$light_delta")
	b=$(darker_channel "${hexinput:4:2}" "$light_delta")

	# Format the result as a six-digit hexadecimal value.
	printf '%02x%02x%02x\n' "$r" "$g" "$b"
}

# This function reloads the icon theme.
reload(){
	if [[ "$XDG_SESSION_TYPE"  == "wayland" ]]; then
		gsettings set org.gnome.desktop.interface icon-theme 'Papirus' &&
		gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
	else
		xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus" &&
		xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
	fi
}

# Parse command line arguments.
if [[ -n "$1" ]] && [[ "$1" =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then # checks if the provided color is a valid hex value
	ICONS_COLOR=${1:1} # remove leading hash symbol
else
	echo "No valid color was provided"
	exit
fi

# Set default values for icon colors.
dir="/usr/share/icons/"
light_folder_fallback="$ICONS_COLOR"
medium_base_fallback="$(darker "$ICONS_COLOR" 20)"
dark_stroke_fallback="$(darker "$ICONS_COLOR" 56)"

# Set the values for the actual icon colors, using the fallbacks if necessary.
# The values for ICONS_SYMBOLIC_ACTION and ICONS_SYMBOLIC_PANEL are set to the values of the MENU_FG and HDR_FG environment variables, respectively.
: "${ICONS_LIGHT_FOLDER:=$light_folder_fallback}"
: "${ICONS_MEDIUM:=$medium_base_fallback}"
: "${ICONS_DARK:=$dark_stroke_fallback}"
: "${ICONS_SYMBOLIC_ACTION:=${MENU_FG:-}}"
: "${ICONS_SYMBOLIC_PANEL:=${HDR_FG:-}}"

# For each icon size, update the corresponding icons by replacing the accent colors in the SVG files
# and creating symlinks with the new names
for size in 24x24 32x32 48x48 64x64; do
	for icon_path in \
		"$dir/Papirus/$size/places/folder-blue"{-*,}.svg \
		"$dir/Papirus/$size/places/user-blue"{-*,}.svg
	do
		# If the file does not exist or is already a symlink, skip it
		[ -f "$icon_path" ] || continue
		[ -L "$icon_path" ] && continue

		# Construct the new icon name and symlink path by replacing the "-custom" suffix with "-pywal"
		new_icon_path="${icon_path/-blue/-pywal}"
		icon_name="${new_icon_path##*/}"
		symlink_path="${new_icon_path/-pywal/}"  # remove color suffix

		# Replace the accent colors in the SVG file using sed and save it to the new icon path
		sed -e "s/5294e2/$ICONS_LIGHT_FOLDER/g" \
			-e "s/4877b1/$ICONS_MEDIUM/g" \
			-e "s/1d344f/$ICONS_DARK/g" "$icon_path" > "$new_icon_path"

		# Create a symbolic link with the new name and remove the color suffix
		ln -sf "$icon_name" "$symlink_path"
	done
done

# Reload the icon theme to apply the changes
reload
