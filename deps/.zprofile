#!/usr/bin/env bash

#                       _____ __   
#     ____  _________  / __(_) /__ 
#    / __ \/ ___/ __ \/ /_/ / / _ \
#   / /_/ / /  / /_/ / __/ / /  __/
#  / .___/_/   \____/_/ /_/_/\___/ 
# /_/                              
#

# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# Set default mime types
export TERMINAL="alacritty"
export BROWSER="firefox"
export QT_QPA_PLATFORMTHEME="qt5gtk2"

# Polybar and bspwm style settings
bar_style=bionic
window_border="3"

if [[ "$bar_style" == "base" ]];then
	top_padding="23"
	bottom_padding="23"
	conky="On"
elif [[ "$bar_style" == "minimal" ]];then
	top_padding="0"
	bottom_padding="25"
	conky="Off"
elif [[ "$bar_style" == "bionic" ]];then
	top_padding="35"
	bottom_padding="0"
	conky="On"
fi
