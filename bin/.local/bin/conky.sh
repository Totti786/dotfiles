#!/bin/bash

conkyConfig=$HOME/.config/conky/conky-Openbox.conf

if [ -z "$(pgrep conky)" ]; then 
	conky -c $conkyConfig &> /dev/null
else
	pkill conky
fi
