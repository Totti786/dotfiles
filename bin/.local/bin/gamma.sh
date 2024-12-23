#!/usr/bin/env bash

# Variables
gamma_mode=off
temperature=4000
increment=200

# Function to change gamma mode state in the script
change_mode() {
  sed -i "s/gamma_mode=$1/gamma_mode=$2/g" "$0"
  gamma_mode="$2"
  echo "$gamma_mode"
}

# Function to change temperature value and apply it using gammastep
change_temp() {
  if (( "$2" > 1000 )) && (( "$2" < 16000 )); then
    sed -i "s/temperature=$1/temperature=$2/g" "$0"
    gammastep -P -O $((temperature + increment))
  fi
}

# Check if clight is running
if pgrep clight > /dev/null && [[ -n "$(clight.sh --gamma-status)"  ]]; then
  # Use clight if it is running
  case "$1" in 
    --toggle)
      clight.sh --toggle-gamma
      #[[ $(pidof polybar) ]] && polybar-msg action "#auto-gamma.hook.1"
	  ;;
    --toggle-ambient)
      clight.sh --toggle-ambient-gamma
	  ;;
    --increase)
      clight.sh --increase-gamma
      ;;
    --decrease)
      clight.sh --decrease-gamma
      ;;
    *)
		gamma_status="$(clight.sh --gamma-status)"
		gamma="$(clight.sh --gamma)"
		if [[ "$gamma" -eq "6400" && "$gamma_status" == "false" ]]; then
			echo "Off"
			#[[ $(pidof polybar) ]] && polybar-msg action "#auto-gamma.hook.0"
		else
			echo "${gamma}K"
			#if [[ "$status"  == "false" ]] && [[ $(pidof polybar) ]]; then 
				#polybar-msg action "#auto-gamma.hook.1"
			#else
				#polybar-msg action "#auto-gamma.hook.2"
			#fi
		fi
      ;;
  esac
else
  # Fallback to gammastep logic if clight is not running
  case "$1" in
    --toggle)
      if [ "$gamma_mode" = "on" ]; then
        change_mode "$gamma_mode" "off"
        gammastep -x
      else
        change_mode "$gamma_mode" "on"
        gammastep -O "$temperature"
      fi
      ;;
    --state)
      if [ "$gamma_mode" = "on" ]; then
        echo "on"
      else
        echo "off"
      fi
      ;;
    --increase)
      if [ "$gamma_mode" = "on" ]; then
        change_temp "$temperature" $((temperature + increment))
      fi
      ;;
    --decrease)
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
fi
