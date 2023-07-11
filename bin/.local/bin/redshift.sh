#!/bin/bash

REDSHIFT=off
REDSHIFT_TEMP=4600
CHANGE_VALUE=200

changeMode() {
  sed -i "s/REDSHIFT=$1/REDSHIFT=$2/g" "$0"
  REDSHIFT=$2
  echo "$REDSHIFT"
}

changeTemp() {
  if (( "$2" > 1000 )) && (( "$2" < 25000 )); then
    sed -i "s/REDSHIFT_TEMP=$1/REDSHIFT_TEMP=$2/g" "$0"
    redshift -P -O $((REDSHIFT_TEMP + CHANGE_VALUE))
  fi
}

case $1 in
  toggle)
    if [ "$REDSHIFT" = "on" ]; then
      changeMode "$REDSHIFT" "off"
      redshift -x
    else
      changeMode "$REDSHIFT" "on"
      redshift -O "$REDSHIFT_TEMP"
    fi
    ;;
  state)
    if [ "$REDSHIFT" = "on" ]; then
      echo "on"
    else
      echo "off"
    fi
    ;;
  increase)
    if [ "$REDSHIFT" = "on" ]; then
      changeTemp "$REDSHIFT_TEMP" $((REDSHIFT_TEMP + CHANGE_VALUE))
    fi
    ;;
  decrease)
    if [ "$REDSHIFT" = "on" ]; then
      changeTemp "$REDSHIFT_TEMP" $((REDSHIFT_TEMP - CHANGE_VALUE))
    fi
    ;;
  *)
    case $REDSHIFT in
      on)
        printf "%dK" "$REDSHIFT_TEMP"
        ;;
      off)
        printf "Off"
        ;;
    esac
    ;;
esac
