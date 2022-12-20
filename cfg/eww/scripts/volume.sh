#!/bin/bash

# @requires: pamixer

percentage () {
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

get_percentage() {
  local muted=$(pamixer --get-mute)
  if [[ $muted == 'true' ]]; then
    echo "muted"
  else
    pamixer --get-volume-human
  fi
}

get_icon () {
  local vol=$(get_percentage)
  if [[ $vol == "muted" ]]; then
    echo "婢"
  else
    echo $(percentage "$vol" "" "" "墳" "")
  fi
}

get_vol () {
  local percent=$(get_percentage)
  echo $percent | tr -d '%'
}

case $1 in
    icon)
        get_icon
        ;;
    vol)
        get_vol 
        ;;
	set)
		pamixer --set-volume $2
        ;;
esac
