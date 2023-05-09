#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
theme="Arch"

changeDM(){
current="$(grep 'ExecStart=' /etc/systemd/system/display-manager.service | cut -f2 -d  "=")"
	
	if [ "$current" == "/usr/bin/gdm" ]; then
		echo "The Current Display Manager is GDM"
		sudo systemctl disable gdm.service && 
		installSDDM
	elif [ "$current" == "/usr/bin/lightdm" ]; then
		echo "The Current Display Manager is LightDM"
		sudo systemctl disable lightdm.service && 
		installSDDM
	else 
		echo "$current"
		installSDDM
	fi
}

installSDDM(){
if command -v sddm &> /dev/null; then
	if [ -d "/usr/share/sddm/themes/$theme" ]; then  
		if [ -f "/etc/sddm.conf.d/theme.conf" ];then
			echo "theme conf file found, moving files" 
			sudo sed -i -e "s/Current=.*/Current=$theme/g" /etc/sddm.conf.d/theme.conf
		else
			echo "theme conf file not found, creating and moving files" 
			sudo mkdir /etc/sddm.conf.d/
			sudo cp "./theme.conf" /etc/sddm.conf.d/ &&
			sudo sed -i -e "s/Current=.*/Current=$theme/g" /etc/sddm.conf.d/theme.conf
			cp "./.face" "$HOME"/.face
		fi
	else 
		sudo cp -r "./$theme" /usr/share/sddm/themes/ &&
		installSDDM
	fi
else
	sudo pacman -Sy sddm plasma-framework --noconfirm && 
	sudo systemctl enable sddm.service && 
	installSDDM
fi	
}

changeDM
