#!/usr/bin/env bash

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

apply_ags() {
	apply_hypr
    sass "$HOME"/.config/ags/scss/main.scss "$HOME"/.cache/ags/user/generated/style.css
    ags run-js 'openColorScheme.value = true; Utils.timeout(2000, () => openColorScheme.value = false);'
    ags run-js "App.resetCss(); App.applyCss('${HOME}/.cache/ags/user/generated/style.css');"
}

# check if the file ~/.cache/ags/user/colormode.txt exists. if not, create it. else, read it to $lightdark
colormodefile="$HOME/.cache/ags/user/colormode.txt"
lightdark="dark"
transparency="opaque"
materialscheme="vibrant"
terminalscheme="$HOME/.config/ags/scripts/templates/terminal/scheme-base.json"

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
backend="pywal" # color generator backend
if [ ! -f "$HOME/.cache/ags/user/colorbackend.txt" ]; then
    echo "material" > "$HOME/.cache/ags/user/colorbackend.txt"
else
    backend=$(cat "$HOME/.cache/ags/user/colorbackend.txt") # either "" or "-l"
fi

cd "$HOME/.config/ags/scripts/" || exit
if [[ "$1" = "#"* ]]; then # this is a color
    color_generation/generate_colors_material.py --color "$1" \
    --mode "$lightdark" --scheme "$materialscheme" --transparency "$transparency" \
    --termscheme $terminalscheme --blend_bg_fg \
    > "$HOME"/.cache/ags/user/generated/material_colors.scss
    if [ "$2" = "--apply" ]; then
        cp "$HOME"/.cache/ags/user/generated/material_colors.scss "$HOME/.config/ags/scss/_material.scss"
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
    --cache "$HOME/.cache/ags/user/color.txt" $smartflag \
    > "$HOME"/.cache/ags/user/generated/material_colors.scss
    if [ "$2" = "--apply" ]; then
        cp "$HOME"/.cache/ags/user/generated/material_colors.scss "$HOME/.config/ags/scss/_material.scss"
        apply_ags &
    fi
elif [ "$backend" = "pywal" ]; then
    # copy scss
    cp "$HOME/.cache/wal/colors.scss" "$HOME"/.cache/ags/user/generated/material_colors.scss

    cat color_generation/pywal_to_material.scss >> "$HOME"/.cache/ags/user/generated/material_colors.scss
    if [ "$2" = "--apply" ]; then
		sass "$HOME"/.cache/ags/user/generated/material_colors.scss "$HOME"/.cache/ags/user/generated/colors_classes.scss -s compressed
		
		sed -i "s/{color//g" "$HOME"/.cache/ags/user/generated/colors_classes.scss
		sed -i "s/\./$/g" "$HOME"/.cache/ags/user/generated/colors_classes.scss
		sed -i "s/}/;/g" "$HOME"/.cache/ags/user/generated/colors_classes.scss
		sed -i "s/;/;\n/g" "$HOME"/.cache/ags/user/generated/colors_classes.scss
		
		if [ "$transparency" == "opaque" ]; then
			sed -i '1i\$darkmode: True;\n$transparent: False;\n' "$HOME"/.cache/ags/user/generated/colors_classes.scss
        else
			sed -i '1i\$darkmode: True;\n$transparent: True;\n' "$HOME"/.cache/ags/user/generated/colors_classes.scss
        fi

		cp "$HOME"/.cache/ags/user/generated/colors_classes.scss "$HOME"/.config/ags/scss/_material.scss
    
        apply_ags &
    fi
fi
