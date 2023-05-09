#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

#---- Core functions ---------------------

checkChaotic(){
	chaotic="$(grep -i "chaotic" /etc/pacman.conf | head -n1)"
	if [[ "$chaotic" == "[chaotic-aur]" ]]; then 
		echo "The Chaotic AUR repo is already added"
		checkYay
	else
		echo "Adding the Chaotic AUR repo"
		sh "$DIR"/deps/chaotic-aur
		checkYay
	fi
	}
	
checkYay(){
	if ! pacman -Q yay &> /dev/null; then 
		echo "Installing the AUR helper yay..."
		sudo pacman -Syu yay
	else
		echo "The AUR helper yay is already installed"
	fi
	}

installDependencies(){
	sudo pacman -Sy "$(cat "$DIR"/deps/minimal.txt)" --needed
	sudo pacman -U "$DIR"/deps/packages/*.zst --needed
	}

minimal(){
	checkChaotic &&
	installDependencies &&
	xdg-user-dirs-update &&	xdg-user-dirs-gtk-update
	moveConfigs
	changeTheme
	}

base(){
	minimal
	sudo pacman -U "$DIR"/deps/packages/additional/*.zst --needed
	}

moveConfigs(){
	sudo cp -r "$DIR"/bin/usr/ / && echo "moved bin to /usr/local"
	cp -r "$DIR"/bin/.scripts/ "$HOME"/ && echo "moved scripts home"
	cp -r "$DIR"/cfg/* "$HOME"/.config/ && echo "moved config files"
	cp -r "$DIR"/bin/.local/ "$HOME" && echo "moved bin"
	cp -r "$DIR"/deps/.zprofile "$HOME"/
	
    mkdir -p "$HOME/.local/share/icons"
    mkdir -p "$HOME/.local/share/fonts"
    
    tar -xf "$DIR"/deps/Papirus-icons.tar.gz -C "$HOME/.local/share/icons"
	tar -xf "$DIR"/deps/fonts.tar.gz -C "$HOME/.local/share/fonts"
	}
	
changeTheme(){
	if ! [[ "$(grep -i "qt5ct" /etc/environment | head -n1)" == "QT_QPA_PLATFORMTHEME=\"qt5ct\"" ]]; then
		echo "QT_QPA_PLATFORMTHEME=\"qt5ct\"" | sudo tee -a /etc/environment > /dev/null
	fi
	xfconf-query -c xsettings -p /Net/ThemeName -s "FlatColor"
	xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"	
	cat "$DIR/cfg/plank.conf" | dconf load /net/launchpad/plank/docks/
	cp -r "$DIR"/bin/.icons "$HOME"/

	}

wpgtk(){
	sh "$DIR"/bin/.local/bin/wpgtk run &&
	if $Dialog --yesno "Do you want your Login Screen background to sync with your wallpaper? 
			(This only works with the included SDDM theme)" 20 60 ;then
		sh "$DIR"/bin/.local/bin/wpgtk lockPerms &&
		sh "$DIR"/bin/.local/bin/wpgtk wall "$DIR"/deps/background.jpg 
	else
		sh "$DIR"/bin/.local/bin/wpgtk wall "$DIR"/deps/background.jpg
		exit
	fi
	}


#---- Additional configurations ----------

install_zsh(){
	sh "$DIR"/deps/zsh/zsh.sh
	}
	
install_sddm(){
	cd "$DIR"/deps/sddm && sh sddm.sh && cd "$DIR"
	}
	
install_grub(){
	cd "$DIR"/deps/grub && sudo sh grub.sh && cd "$DIR"
	}

wallpapers(){
	if [[ -d "$HOME/Pictures/Wallpapers/Wallpapers.git" ]]; then
		cd "$HOME"/Pictures/Wallpapers/Wallpapers.git
		git pull
	else 
		mkdir -p "$HOME"/Pictures/Wallpapers
		git clone --depth 1 https://github.com/Totti786/Wallpapers.git "$HOME"/Pictures/Wallpapers/Wallpapers.git
	fi
	}

#---- TUI functions  ---------------------

Dialog="dialog"

menu(){
	if $Dialog --yesno "$1" 20 60 ;then	"$2" ;else "$3" ;fi
	}

progressBar(){
	for i in $(seq 1 100);do
	date +"$(printf $i $i)"
	sleep .0005
	done | "$Dialog" --gauge "$1" 20 60 0
	}

additionalPrograms(){
	if $Dialog --yesno "Do you want to select wich additional apps you want to install?\n	
		Seleceting \"No\" will install all the additional apps" 20 60 ;then
	  	progs=$($Dialog --no-items --checklist "Choose the programs you want installed:"  20 60 12 \
		$(for app in $(cat "$DIR"/deps/extra.txt); do echo "$app" off ;done) \
		2>&1 >/dev/tty) &&
		sudo pacman -Sy "$progs" --needed
	else
		sudo pacman -Sy $(cat "$DIR"/deps/extra.txt) --needed
	fi
	}

update(){
	## update dependencies and install new ones
	installDependencies
	progressBar "Updating... "
	## backup weather info file
	[ -f "$HOME/.config/polybar/scripts/info" ] &&
		cp "$HOME"/.config/polybar/scripts/info "$HOME"/.cache/info
	[ ! -f "$HOME/.zprofile" ] && 
		"$DIR"/deps/.zprofile "$HOME"/
	## move udpated scripts and configs
	sudo cp -r "$DIR"/bin/usr/ /
	cp -r "$DIR"/bin/.scripts/ "$HOME"/ 
	cp -r "$DIR"/cfg/* "$HOME"/.config/
	cp -r "$DIR"/bin/.local/ "$HOME"/
	# restore weather info file
	cp "$HOME"/.cache/info "$HOME"/.config/polybar/scripts/info
	}

install(){
	installOptions=$($Dialog --radiolist  "Choose one of the following options:"  15 60 4\
		base "Install with optional useful utilities" off\
		minimal "Install only the essential dependencies" off\
		zsh "Zsh Configuration" off\
		sddm "SDDM Theme" off\
		grub "Grub Theme" off\
		wpgtk "Generate color-schemes from wallpapers" off\
		2>&1 >/dev/tty)
	"$installOptions"
	}

main(){
	OPTIONS=(1 "Install"
	         2 "Install Additional Packages"
	         3 "Update"
	         4 "Download Wallpapers"
	         5 "Update Script"
	         6 "Exit")
	
	CHOICE=$($Dialog --clear \
	                --title "Install Script" \
	                --menu "Choose one of the following options:" \
	                15 40 4 \
	                "${OPTIONS[@]}" \
	                2>&1 >/dev/tty)
	clear
	
	case $CHOICE in
		1)
			install &&
			main
			;;
		2)
			additionalPrograms
			main
			;;
		3)
			git pull 
			update
			main		
			;;
		4)
			wallpapers
			main
			;;
		5)
			git pull
			sh "$DIR"/install.sh
			;;
		6)
			exit
			;;
	esac
	}

if [[ "$1" == "--update" ]]; then
	git pull
	update
elif [[ "$1" == "--wallpapers" ]]; then
	wallpapers
else
	if command -v $Dialog &> /dev/null; then 
		main
	else 
		sudo pacman -S $Dialog &&
		main
	fi
fi
