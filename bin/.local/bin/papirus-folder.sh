#!/usr/bin/env bash

darker_channel() {
	local value="0x$1"
	local light_delta="0x$2"
	local -i result

	result=$(( value - light_delta ))

	(( result < 0   )) && result=0
	(( result > 255 )) && result=255

	echo "$result"
}


darker() {
	local hexinput="$1"
	local light_delta=${2-10}

	r=$(darker_channel "${hexinput:0:2}" "$light_delta")
	g=$(darker_channel "${hexinput:2:2}" "$light_delta")
	b=$(darker_channel "${hexinput:4:2}" "$light_delta")

	printf '%02x%02x%02x\n' "$r" "$g" "$b"
}

reload(){
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark1" &&
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"
}


while [[ $# -gt 0 ]]
do
	case "$1" in
		-h|--help)
			print_usage 0
			;;
		-o|--output)
			OUTPUT_THEME_NAME="$2"
			shift
			;;
		-d|--destdir)
			output_dir="$2"
			shift
			;;
		-c|--color)
			ICONS_COLOR="${2#\#}"  # remove leading hash symbol
			shift
			;;
		-*)
			echo "unknown option $1"
			print_usage 2
			;;
		*)
			THEME="$1"
			;;
	esac
	shift
done

dir="$HOME/.local/share/icons/"

trap EXIT SIGHUP SIGINT SIGTERM


: "${ICONS_COLOR:=$SEL_BG}"
: "${OUTPUT_THEME_NAME:=oomox-$THEME}"

light_folder_fallback="$ICONS_COLOR"
medium_base_fallback="$(darker "$ICONS_COLOR" 20)"
dark_stroke_fallback="$(darker "$ICONS_COLOR" 56)"

: "${ICONS_LIGHT_FOLDER:=$light_folder_fallback}"
: "${ICONS_MEDIUM:=$medium_base_fallback}"
: "${ICONS_DARK:=$dark_stroke_fallback}"
: "${ICONS_SYMBOLIC_ACTION:=${MENU_FG:-}}"
: "${ICONS_SYMBOLIC_PANEL:=${HDR_FG:-}}"

#echo ":: Replacing accent colors..."
for size in 22x22 24x24 32x32 48x48 64x64; do
	for icon_path in \
		"$dir/Papirus/$size/places/folder-custom"{-*,}.svg \
		"$dir/Papirus/$size/places/user-custom"{-*,}.svg
	do
		[ -f "$icon_path" ] || continue  # it's a file
		[ -L "$icon_path" ] && continue  # it's not a symlink

		new_icon_path="${icon_path/-custom/-oomox}"
		icon_name="${new_icon_path##*/}"
		symlink_path="${new_icon_path/-oomox/}"  # remove color suffix

		sed -e "s/value_light/$ICONS_LIGHT_FOLDER/g" \
			-e "s/value_dark/$ICONS_MEDIUM/g" \
			-e "s/323232/$ICONS_DARK/g" "$icon_path" > "$new_icon_path"

		ln -sf "$icon_name" "$symlink_path"
	done
done
reload
