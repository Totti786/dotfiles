#!/bin/bash

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

# Polybar and bspwm style settings
export bar_style=minimal
export window_border="3"

if [[ "$bar_style" == "base" ]];then
	export top_padding="23"
	export bottom_padding="23"
	export conky="On"
elif [[ "$bar_style" == "minimal" ]];then
	export top_padding="0"
	export bottom_padding="25"
	export conky="Off"
fi
