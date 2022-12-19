#!/bin/sh

vpn="$(nmcli -t -f name,type connection show --order name --active 2>/dev/null | grep vpn | head -1 | cut -d ':' -f 1)"

status(){
	if [ -n "$vpn" ]; then
		echo "On"
	else
		echo "Off"
	fi
}

toggle(){
	name="$(nmcli -t -f name,type connection show --order name | grep vpn | head -1 | cut -d ':' -f 1 )"
	status="$(nmcli con show --active | grep vpn)"
	if [ -n "$status" ]; then
		nmcli con down $name
	else 
		nmcli con up $name
	fi
}

if [[ "$1"  == "status" ]]; then 
	status
elif [[ "$1"  == "toggle" ]]; then
	toggle
fi
