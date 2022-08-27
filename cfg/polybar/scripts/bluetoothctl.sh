#!/bin/sh

if bluetoothctl show | grep -q "Powered: no"; then
	echo " Bluetooth Off" 
elif bluetoothctl show | grep -q "Powered: yes"; then
	if $(bluetoothctl devices Connected) &> /dev/null; then
		echo " Not Connected"
	else 
		echo  $(bluetoothctl devices Connected | head -n1 | cut -d " " -f3,4,5)
	fi
fi
