#!/bin/bash

conkyConfig=$HOME/.config/conky/conky-$(wmctrl -m |sed -n 1p | sed -e 's/Name: //g').conf

if [ -z "$(pgrep conky)" ]; then 
	conky -c $conkyConfig &> /dev/null
else
	pkill conky
fi
