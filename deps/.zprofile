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
