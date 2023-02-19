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

if [ -d "$HOME/.bin" ]; then
  PATH="$HOME/.bin:$PATH"
fi

# Set default mime types
export TERMINAL="alacritty"
export BROWSER="firefox"

# Polybar and bspwm style settings
style=base
border="2"

if [[ $style == "base" ]];then
	tp="23"
	bp="23"
	conky="On"
elif [[ $style == "minimal" ]];then
	tp="0"
	bp="25"
	conky="Off"
fi
