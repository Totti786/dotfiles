#!/bin/bash

symbol() {
  if [[ $(cat /sys/class/net/enp*/operstate) == "up" ]]; then
    echo 󰈀
  elif [[ $(cat /sys/class/net/w*/operstate) == "up" ]]; then
    echo 󰤨
  elif [[ $(cat /sys/class/net/enp*/operstate) == "down" ]]; then
    echo 󰈂
  elif [[ $(cat /sys/class/net/w*/operstate) == "down" ]]; then
    echo 󰤭
  fi
}

name() {
  nmcli -t -f name connection show --active | head -n1
}

cut() {
  toshow="$1"
  maxlen="$2"

  sufix=""

  if test $(echo $toshow | wc -c) -ge $maxlen ; then
    sufix=""
  fi

  echo "${toshow:0:$maxlen}$sufix"
}

radio_status() {
  radio_status=$(nmcli radio wifi)
  if [[ $radio_status == "enabled" ]]; then
    echo "on"
  else
    echo "off"
  fi
}

case $1 in
	"icon")
        symbol
    ;;
    "ssid")
        ssid=$(name)
		if [[ "$ssid" == "" ]]; then
			cut "Disconnected" 10
		else
			cut "$ssid" 10
		fi
    ;;
    #"name" || "class")
    "name")
        wifiname=$(name)
		if [[ $wifiname == "" ]]; then
			if [[ $1 == "name" ]]; then
				echo "Disconnected"
			elif [[ $1 == "class" ]]; then
				echo "disconnected"
			fi
		else
		    if [[ $1 == "name" ]]; then
		      echo "Connected to $wifiname"
		    elif [[ $1 == "class" ]]; then
		      echo "connected"
		    fi
		fi
    ;;
	"status")
		name=$(name)
		if [[ $name != "" ]]; then
			echo "Connected"
		else
			echo "Disconnected"
		fi
    ;;
	"disconnect")
		local wifiname="nmcli d | grep wifi | sed 's/^.*wifi.*connected//g' | xargs"
		nmcli con down id "${wifiname}"
    ;;
	"radio-status")
		radio_status
    ;;
	"toggle-radio")
		stat=$(radio_status)
		if [[ $stat == "on" ]]; then
			nmcli radio wifi off
		else
			nmcli radio wifi on
		fi
    ;;
esac
