#!/bin/bash
# see man zscroll for documentation of the following parameters
zscroll -l 50 \
        --delay 0.7 \
        --scroll-padding " " \
        --match-command "`dirname $0`/get_media_status.sh --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check true "`dirname $0`/get_media_status.sh" &

wait
