#!/bin/sh

get(){
	btstatus="$(systemctl  status bluetooth.service | grep -i "Active:" | cut -d " " -f7)"
	
	if [[ "$btstatus" == "active" ]]; then
		if bluetoothctl show | grep -q "Powered: no"; then
			echo " Bluetooth Off" 
		elif bluetoothctl show | grep -q "Powered: yes"; then
			if [[ -z $(bluetoothctl devices Connected) ]]; then
				echo " Not Connected"
			else 
				echo " $(bluetoothctl devices Connected | head -n1 | cut -d " " -f3-7)"
			fi
		fi	
	else 
		echo " Bluetooth Unavailable" 
	fi
}

connect(){
	device=$(bluetoothctl devices Paired | head -n1 | cut -d " " -f2)
	name=$(bluetoothctl devices Paired | head -n1 | cut -d " " -f3-7)

	if bluetoothctl show | grep -q "Powered: yes"; then
		if [[ "$(bluetoothctl info)" = "Missing device address argument" ]]; then
			bluetoothctl connect "$device" && notify-send -r 98 -u low --app-name=Bluetooth "$name" "Connected"
		else
			bluetoothctl disconnect && notify-send -r 98 -u low --app-name=Bluetooth "$name" "Disconnected"
		fi
	else 
		bluetoothctl power on
		connect
	fi
}

if [[ ! "$1" ]];then get ;else connect ;fi
