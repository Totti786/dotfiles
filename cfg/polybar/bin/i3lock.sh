#!/bin/bash

lock() {


    i3lock -n -c 00000000 -t -e --pass-media-keys --pass-power-keys --pass-volume-keys --indicator --force-clock \
        --radius 52 --modif-size=9 --modif-pos="w/2:h/2-15" \
        \
        --time-str="%H:%M" \
        --time-pos="w/2:h/4" \
        --time-color=#FFFFFF \
        --time-size=160 \
        --time-font="JetBrainsMono Nerd Font" \
        \
        --date-str="%A, %B %d" \
        --date-pos="w/2:h/4+40" \
        --date-color=#FFFFFF \
        --date-size=35 \
        --date-font="JetBrainsMono Nerd Font" \
        \
        --verif-text="" \
        --verif-color=7ba5dd \
        --verif-size=10 \
        --verif-font="JetBrainsMono Nerd Font" \
        \
        --wrong-text="" \
        --wrong-color=ee6a70 \
        --wrong-size=10 \
        --wrong-font="JetBrainsMono Nerd Font" \
        \
        --greeter-text="" \
        --greeter-color=#FFFFFF \
        --greeter-size=60 \
        --greeter-font="JetBrainsMono Nerd Font" \
        --greeter-pos="w/2:h/2+285" \
        \
        --ring-color=00000000 \
        --ringver-color=96D6B0 \
        --ringwrong-color=ee6a70 \
        --ring-width=10 \
        \
        --insidever-color=079A8C02 \
        --insidewrong-color=079A8C02 \
        --inside-color=079A8C02 \
        --ind-pos="w/2:h-130" \
        \
        --noinput-text="" \
        \
        --line-uses-inside --keyhl-color=7ba5dd --bshl-color=ee6a70 --separator-color=7ba5dd \
        \
        --pointer=default
}


run() {
    lock
}

status=$(playerctl -p %any status || true)
if [ "$status" == "Playing" ]; then
	playerctl pause
fi

if [[ ! -f "$LOCK_FILE" ]]; then
    if pgrep -x rofi; then
        killall rofi
    fi
    run
fi

if [ "$status" == "Playing" ]; then
    playerctl play
fi
