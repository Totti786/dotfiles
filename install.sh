#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#---- Core functions ---------------------

checkChaotic(){
	chaotic="$(grep -i "chaotic" /etc/pacman.conf | head -n1)"
	if [[ $chaotic == "[chaotic-aur]" ]]; then 
		echo "The Chaotic AUR repo is already added"
		checkYay
	else 
		echo "Adding the Chaotic AUR repo"
		sh $DIR/deps/chaotic-aur
		checkYay
	fi
	}
	
checkYay(){
	if ! pacman -Q yay &> /dev/null; then 
		echo "Installing the AUR helper yay..."
		sudo pacman -U $DIR/deps/yay.tar.zst
	else 
		 echo "The AUR helper yay is already installed"
	fi
	}

installDependencies(){
		yay -Sy - < $DIR/deps/minimal.txt --needed
		sudo pacman -U $DIR/deps/packages/* --needed
	}

moveConfigs(){
	sudo cp -r $DIR/bin/bin/ /usr/local/ && echo "moved bin to /usr/local"
	cp -r $DIR/bin/.scripts/ ~/ && echo "moved scripts home" 
	cp -r $DIR/cfg/* ~/.config && echo "moved config files"
	cp -r $DIR/bin/.local/ ~/ && echo "moved icons"
	# extracts the icons and moves them to the correct directory
	tar -xzf $DIR/deps/Papirus-icons.tar.gz -C ~/.local/share/icons 
	# extracts the fonts and moves them to the correct directory
	tar -xzf $DIR/deps/fonts.tar.gz -C ~/.local/share/fonts 
	}

changeTheme(){
	xfconf-query -c xsettings -p /Net/ThemeName -s "FlatColor"
	xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"	
	cp -r $DIR/bin/.icons ~/
	echo "QT_QPA_PLATFORMTHEME=\"qt5ct\"" | sudo tee -a /etc/environment > /dev/null
	}

wpgtk(){
	sh $DIR/bin/.local/bin/wpgtk &&
	sh $DIR/bin/.local/bin/wpgtk setWall $DIR/deps/background.jpg 
	sh $DIR/bin/.local/bin/wpgtk lockWal
	}

minimal(){
	checkChaotic &&
	installDependencies &&
	xdg-user-dirs-update &&
	xdg-user-dirs-gtk-update
	moveConfigs
	changeTheme
	wpgtk
	}

#---- Additional configurations ----------

zsh(){
	sh $DIR/deps/zsh/zsh.sh
	}
	
sddm(){
	cd $DIR/deps/sddm && sh sddm.sh && cd $DIR
	}
	
grub(){
	cd $DIR/deps/grub && sudo sh grub.sh && cd $DIR
	}

wallpapers(){
	if [[ -d "$HOME/Pictures/Wallpapers" ]]; then
		git clone https://github.com/Totti786/Wallpapers.git ~/Pictures/Wallpapers1 &&
		mv ~/Pictures/Wallpapers1/* ~/Pictures/Wallpapers &&
		rm -rf ~/Pictures/Wallpapers	
	else 
		mkdir ~/Pictures/Wallpapers &&
		git clone https://github.com/Totti786/Wallpapers.git ~/Pictures/Wallpapers1 &&
		mv ~/Pictures/Wallpapers1/* ~/Pictures/Wallpapers &&
		rm -rf ~/Pictures/Wallpapers	
	fi
}

#---- TUI functions  ---------------------

menu(){
	if dialog --yesno "$1" 20 60 ;then
		$2
	else
		$3
	fi
	}

progressBar(){
	for i in `seq 1 100`;do
	date +"`printf $i $i`"
	sleep .0005
	done | dialog --gauge "$1" 20 60 0
	}

additionalPrograms(){
	if dialog --yesno "Do you want to select wich additional apps you want to install?\n	
		Seleceting \"No\" will install all the additional apps" 20 60 ;then
	  	progs=$(dialog --no-items --checklist "Choose the programs you want installed:"  20 60 12 \
		$(for app in $(cat $DIR/deps/extra.txt); do	echo "$app" off ;done) \
		2>&1 >/dev/tty) &&
		sudo pacman -Sy $progs --needed
	else
		sudo pacman -Sy - < $DIR/deps/extra.txt --needed
	fi
}

update(){
	moveConfigs
	progressBar "Updating... "
	}

install(){
	installOptions=$(dialog --radiolist  "Choose one of the following options:"  15 40 4\
		minimal "Minimal Install" off\
		zsh "Zsh Configuration" off\
		sddm "SDDM Theme" off\
		grub "Grub Theme" off\
		2>&1 >/dev/tty)
	$installOptions
	}

main(){
	OPTIONS=(1 "Install"
	         2 "Install Additional Packages"
	         3 "Update"
	         4 "Download Wallpapers"
	         5 "Exit")
	
	CHOICE=$(dialog --clear \
	                --title "Install Script" \
	                --menu "Choose one of the following options:" \
	                15 40 4 \
	                "${OPTIONS[@]}" \
	                2>&1 >/dev/tty)
	clear
	
	case $CHOICE in
		1)
			install 
			main
			;;
		2)
			additionalPrograms
			main
			;;
		3)
			update
			main		
			;;
		4)
			wallpapers
			main
			;;
		5)
			exit
			;;
	esac
}

if command -v dialog &> /dev/null; then 
	main
else 
	sudo pacman -S dialog &&
	main
fi
