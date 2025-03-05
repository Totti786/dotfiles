#!/usr/bin/env python3

import os
import re
import shutil
import subprocess

def get_colors_from_bash(bash_file):
    colors = {}
    with open(bash_file, 'r') as file:
        for line in file:
            match = re.match(r'(\w+)=\"(#(?:[0-9A-Fa-f]{6}|[0-9A-Fa-f]{3}))\"', line)
            if match:
                colors[match.group(1)] = match.group(2)
    return colors

def update_config_colors(config_file, colors, mappings):
    """Updates the Kvantum config file with mapped colors."""
    if not os.path.exists(config_file):
        return
    
    with open(config_file, 'r') as file:
        config_content = file.read()

    for key, variable in mappings.items():
        if variable in colors:
            color = colors[variable]
            pattern = rf'({key}=)#?\w+\b'
            new_line = f'\\1{color}'
            if re.search(pattern, config_content):
                config_content = re.sub(pattern, new_line, config_content)
            else:
                config_content += f"\n{key}={color}"

    with open(config_file, 'w') as file:
        file.write(config_content)

def get_light_dark(state_file):
    """Reads the colormode.txt file, defaults to 'dark' if not found."""
    if not os.path.exists(state_file):
        return "dark"  # Default to dark mode if the file doesn't exist
    
    with open(state_file, 'r') as file:
        return file.readline().strip() or "dark"

def apply_theme(xdg_config_home, lightdark):
    """Copies the correct Kvantum theme based on colormode.txt and runs the SVG script if available."""
    theme_dir = os.path.join(xdg_config_home, "Kvantum", "Colloid")
    material_adw_path = os.path.join(xdg_config_home, "Kvantum", "MaterialAdw", "MaterialAdw.kvconfig")
    
    if not os.path.isdir(theme_dir):
        subprocess.run(["notify-send", "Colloid-kde theme required", f"The folder '{theme_dir}' does not exist."])
        return

    if lightdark == "light":
        shutil.copy(os.path.join(theme_dir, "Colloid.kvconfig"), material_adw_path)
        script = os.path.join(xdg_config_home, "Kvantum", "Colloid", "adwsvg.py")
    else:
        shutil.copy(os.path.join(theme_dir, "ColloidDark.kvconfig"), material_adw_path)
        script = os.path.join(xdg_config_home, "Kvantum", "Colloid", "adwsvgDark.py")

    if os.path.exists(script):
        subprocess.run(["python3", script])
    else:
        print(f"Warning: {script} not found, skipping execution.")

if __name__ == "__main__":
    xdg_config_home = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
    xdg_cache_home = os.environ.get("XDG_CACHE_HOME", os.path.expanduser("~/.cache"))
    xdg_state_home = os.environ.get("XDG_STATE_HOME", os.path.expanduser("~/.local/state"))

    colors_file = os.path.join(xdg_cache_home, "wal", "material_colors.sh")
    config_file = os.path.join(xdg_config_home, "Kvantum", "MaterialAdw", "MaterialAdw.kvconfig")
    state_file = os.path.join(xdg_state_home, "ags", "user", "colormode.txt")

    mappings = {
        'window.color': 'background',
        'base.color': 'background',
        'alt.base.color': 'background',
        'button.color': 'surfaceContainer',
        'light.color': 'surfaceContainerLow',
        'mid.light.color': 'surfaceContainer',
        'dark.color': 'surfaceBright',
        'mid.color': 'surfaceContainerHigh',
        'highlight.color': 'primary',
        'inactive.highlight.color': 'primary',
        'text.color': 'onBackground',
        'window.text.color': 'onBackground',
        'button.text.color': 'onBackground',
        'disabled.text.color': 'onBackground',
        'tooltip.text.color': 'onBackground',
        'highlight.text.color': 'onSurface',
        'link.color': 'tertiary',
        'link.visited.color': 'tertiary',
        'progress.indicator.text.color': 'onBackground',
        'text.normal.color': 'onBackground',
        'text.focus.color': 'onBackground',
        'text.press.color': 'onSecondaryContainer',
        'text.toggle.color': 'onSecondaryContainer',
        'text.disabled.color': 'surfaceDim',
    }

    lightdark = get_light_dark(state_file)
    apply_theme(xdg_config_home, lightdark)

    colors = get_colors_from_bash(colors_file)
    update_config_colors(config_file, colors, mappings)

    print("Kvantum theme and colors updated successfully!")
