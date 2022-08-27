#!/bin/bash

device=$(bluetoothctl devices | head -n1 | cut -d " " -f2)
name=$(bluetoothctl devices | head -n1 | cut -d " " -f3,4,5)

toggle(){
	if [[ $(bluetoothctl info) = "Missing device address argument" ]]; then
		bluetoothctl connect $device 
		#&& notify-send "$name Connected"
	else
		bluetoothctl disconnect
		#&& notify-send "$name Disconnected"
	fi
	}

main(){
#if command -v bluetoothctl &> /dev/null; then
	if bluetoothctl show | grep -q "Powered: yes"; then
		 toggle	
		 bluetoothctl power on >> /dev/null
	else 
		bluetoothctl power on
		main
	fi
#else 
	#echo "bluetoothctl not installed"
	#exit 0
#fi
}
main
