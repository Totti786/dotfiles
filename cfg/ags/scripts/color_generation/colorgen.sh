#!/usr/bin/env bash

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
CONFIG_DIR="$XDG_CONFIG_HOME/ags"
CACHE_DIR="$XDG_CACHE_HOME/ags"
STATE_DIR="$XDG_STATE_HOME/ags"

# check if no arguments
if [ $# -eq 0 ]; then
    echo "Usage: colorgen.sh /path/to/image (--apply)"
    exit 1
fi

apply_hypr() {
	if [ "$transparency" == "opaque" ]; then
		sed -i "/^[^#]*opacity/s/^/#/" $HOME/.config/hypr/hyprland.conf
		sed -i "s/alpha=.*/alpha='FF'/" $HOME/.local/bin/wpgtk
		wpgtk transparent
	else
		sed -i "/opacity/s/^#//" $HOME/.config/hypr/hyprland.conf
		sed -i "s/alpha=.*/alpha='70'/" $HOME/.local/bin/wpgtk
		wpgtk transparent
	fi
}

#apply_ags() {
	#apply_hypr
    #sass -I "$STATE_DIR/scss" -I "$CONFIG_DIR/scss/fallback" "$CONFIG_DIR"/scss/main.scss "$CACHE_DIR"/user/generated/style.css
    #ags run-js 'openColorScheme.value = true; Utils.timeout(2000, () => openColorScheme.value = false);'
    #ags run-js "App.resetCss(); App.applyCss('${HOME}/.cache/ags/user/generated/style.css');"
#}

apply_ags() {
    ags run-js "handleStyles(false);"
    ags run-js 'openColorScheme.value = true; Utils.timeout(2000, () => openColorScheme.value = false);'
}

# check if the file $STATE_DIR/user/colormode.txt exists. if not, create it. else, read it to $lightdark
colormodefile="$STATE_DIR/user/colormode.txt"
lightdark="dark"
transparency="opaque"
materialscheme="vibrant"
terminalscheme="$XDG_CONFIG_HOME/ags/scripts/templates/terminal/scheme-base.json"

if [ ! -f $colormodefile ]; then
    echo "dark" > $colormodefile
    echo "opaque" >> $colormodefile
    echo "vibrant" >> $colormodefile
elif [[ $(wc -l < $colormodefile) -ne 3 || $(wc -w < $colormodefile) -ne 3 ]]; then
    echo "dark" > $colormodefile
    echo "opaque" >> $colormodefile
    echo "vibrant" >> $colormodefile
else
    lightdark=$(sed -n '1p' $colormodefile)
    transparency=$(sed -n '2p' $colormodefile)
    materialscheme=$(sed -n '3p' $colormodefile)
fi

backend="material" # color generator backend
if [ ! -f "$STATE_DIR/user/colorbackend.txt" ]; then
    echo "material" > "$STATE_DIR/user/colorbackend.txt"
else
    backend=$(cat "$STATE_DIR/user/colorbackend.txt") # either "" or "-l"
fi

cd "$CONFIG_DIR/scripts/" || exit
if [[ "$1" = "#"* ]]; then # this is a color
    color_generation/generate_colors_material.py --color "$1" \
    --mode "$lightdark" --scheme "$materialscheme" --transparency "$transparency" \
    --termscheme "$terminalscheme" --blend_bg_fg \
    > "$CACHE_DIR"/user/generated/material_colors.scss
    if [ "$2" = "--apply" ]; then
        cp "$CACHE_DIR"/user/generated/material_colors.scss "$STATE_DIR/scss/_material.scss"
        apply_ags &
    fi
elif [ "$backend" = "material" ]; then
    smartflag=''
    if [ "$3" = "--smart" ]; then
        smartflag='--smart'
    fi
    color_generation/generate_colors_material.py --path "$1" \
    --mode "$lightdark" --scheme "$materialscheme" --transparency "$transparency" \
    --termscheme $terminalscheme --blend_bg_fg \
    --cache "$STATE_DIR/user/color.txt" $smartflag \
    > "$CACHE_DIR"/user/generated/material_colors.scss
    if [ "$2" = "--apply" ]; then
        cp "$CACHE_DIR"/user/generated/material_colors.scss "$STATE_DIR/scss/_material.scss"
        apply_ags
    fi
elif [ "$backend" = "pywal" ]; then
    # copy scss
    cp "$XDG_CACHE_HOME/wal/colors.scss" "$CACHE_DIR"/user/generated/material_colors.scss

    cat color_generation/pywal_to_material.scss >> "$CACHE_DIR"/user/generated/material_colors.scss
    if [ "$2" = "--apply" ]; then
		sass "$CACHE_DIR"/user/generated/material_colors.scss "$CACHE_DIR"/user/generated/colors_classes.scss -s compressed
		
		sed -i "s/{color//g" "$CACHE_DIR"/user/generated/colors_classes.scss
		sed -i "s/\./$/g" "$CACHE_DIR"/user/generated/colors_classes.scss
		sed -i "s/}/;/g" "$CACHE_DIR"/user/generated/colors_classes.scss
		sed -i "s/;/;\n/g" "$CACHE_DIR"/user/generated/colors_classes.scss
		
		if [ "$transparency" == "opaque" ]; then
			sed -i '1i\$darkmode: True;\n$transparent: False;\n' "$CACHE_DIR"/user/generated/colors_classes.scss
        else
			sed -i '1i\$darkmode: True;\n$transparent: True;\n' "$CACHE_DIR"/user/generated/colors_classes.scss
        fi

		cp "$CACHE_DIR"/user/generated/colors_classes.scss "$STATE_DIR"/scss/_material.scss
    
        apply_ags &
    fi
fi
