#!/usr/bin/env bash

gamma_mode=off
temperature=3700
increment=200

change_mode() {
  sed -i "s/gamma_mode=$1/gamma_mode=$2/g" "$0"
  gamma_mode="$2"
  echo "$gamma_mode"
}

change_temp() {
  if (( "$2" > 1000 )) && (( "$2" < 16000 )); then
    sed -i "s/temperature=$1/temperature=$2/g" "$0"
    redshift -P -O $((temperature + increment))
  fi
}

case "$1" in
	toggle)
		if [ "$gamma_mode" = "on" ]; then
			change_mode "$gamma_mode" "off"
			gammastep -x
		else
			change_mode "$gamma_mode" "on"
			gammastep -O "$temperature"
		fi
	;;
	state)
		if [ "$gamma_mode" = "on" ]; then
			echo "on"
		else
			echo "off"
		fi
	;;
	increase)
		if [ "$gamma_mode" = "on" ]; then
			change_temp "$temperature" $((temperature + increment))
		fi
	;;
	decrease)
		if [ "$gamma_mode" = "on" ]; then
			change_temp "$temperature" $((temperature - increment))
		fi
	;;
	*)
		case "$gamma_mode" in
			on)
				echo "${temperature}K"
			;;
			off)
				echo "Off"
			;;
		esac
	;;
esac
