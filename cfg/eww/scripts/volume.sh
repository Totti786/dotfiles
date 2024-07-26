#!/bin/bash

# @requires: pamixer

percentage () {
  local val=$(echo $1)
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
  if wpctl get-volume @DEFAULT_SINK@ | grep -q '\[MUTED\]'; then
    echo "muted"
  else
    wpctl get-volume @DEFAULT_SINK@ | awk '{print $2 * 100}'
  fi
}

get_icon () {
  local vol=$(get_percentage)
  if [[ $vol == "muted" ]]; then
    echo ""
  else
    echo $(percentage "$vol" "" "" "" "")
  fi
}

get_vol () {
  local percent=$(get_percentage)
  echo $percent
}

case $1 in
    icon)
        get_icon
        ;;
    vol)
        get_vol 
        ;;
	set)
		wpctl set-volume @DEFAULT_SINK@ ${2}%
        ;;
esac
