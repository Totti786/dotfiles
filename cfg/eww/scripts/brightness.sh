#!/bin/bash

#--Brightness---------#
# @requires: brightnessctl

br_percentage() {
  local val=$(echo $1 | tr '%' ' ' | awk '{print $1}')
  local icon1=$2
  local icon2=$3
  local icon3=$4
  local icon4=$5
  if [ "$val" -le 15 ]; then
    echo $icon1
  elif [ "$val" -le 30 ]; then
    echo $icon2
  elif [ "$val" -le 60 ]; then
    echo $icon3
  else
    echo $icon4
  fi
}

br_get() {
  (( br = $(brightnessctl get) * 100 / $(brightnessctl max) ))
  echo $br
}

br_percent() {
  echo $(br_get)%
}

br_icon () {
  local br=$(br_get)
  echo $(br_percentage "$br" "" "" "" "")
}

case $1 in
    icon)
        br_icon
        ;;
    percent)
        br_percent
        ;;
	br)
		br_get
        ;;
esac
