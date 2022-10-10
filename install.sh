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
		sudo pacman -Sy - < $DIR/deps/minimal.txt --needed
		sudo pacman -U $DIR/deps/packages/* --needed
	}

moveConfigs(){
	sudo cp -r $DIR/bin/bin/ /usr/local/ && echo "moved bin to /usr/local"
	cp -r $DIR/bin/.scripts/ ~/ && echo "moved scripts home" 
	cp -r $DIR/cfg/* ~/.config/ && echo "moved config files"
	cp -r $DIR/bin/.local/ ~/ && echo "moved icons"
	# extracts the icons and moves them to the correct directory
	tar -xzf $DIR/deps/Papirus-icons.tar.gz -C ~/.local/share/icons 
	# extracts the fonts and moves them to the correct directory
	if [[ ! -d "$HOME/.local/share/fonts" ]]; then mkdir ~/.local/share/fonts ;fi
	tar -xzf $DIR/deps/fonts.tar.gz -C ~/.local/share/fonts 
	}
	
# This function allows you to change the plank configuration (courtesy of Archcraft by @adi1090x)
change_dock() {
	cat > "$HOME"/.cache/plank.conf <<- _EOF_
		[dock1]
		alignment='center'
		auto-pinning=true
		current-workspace-only=false
		dock-items=['applications.dockitem', 'Alacritty.dockitem', 'thunar.dockitem', 'firefox.dockitem', 'geany.dockitem', 'xfce-settings-manager.dockitem']
		hide-delay=0
		hide-mode='window-dodge'
		icon-size=32
		items-alignment='center'
		lock-items=false
		monitor=''
		offset=0
		pinned-only=false
		position='left'
		pressure-reveal=false
		show-dock-item=false
		theme='Transparent'
		tooltips-enabled=true
		unhide-delay=0
		zoom-enabled=true
		zoom-percent=120
	_EOF_
}

changeTheme(){
	xfconf-query -c xsettings -p /Net/ThemeName -s "FlatColor"
	xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"	
	change_dock && cat "$HOME"/.cache/plank.conf | dconf load /net/launchpad/plank/docks/
	cp -r $DIR/bin/.icons ~/
	if ! [[ "$(grep -i "qt5ct" /etc/environment | head -n1)" == "QT_QPA_PLATFORMTHEME=\"qt5ct\"" ]]; then
		echo "QT_QPA_PLATFORMTHEME=\"qt5ct\"" | sudo tee -a /etc/environment > /dev/null
	fi
	papirus-folders -R
	}

wpgtk(){
	sh $DIR/bin/.local/bin/wpgtk run &&
	if $Dialog --yesno "Do you want your sddm and grub background to sync with your wallpaper?" 20 60 ;then
		sh $DIR/bin/.local/bin/wpgtk lockPerms &&
		sh $DIR/bin/.local/bin/wpgtk setWall $DIR/deps/background.jpg 
	else
		sh $DIR/bin/.local/bin/wpgtk setWall $DIR/deps/background.jpg
		exit
	fi
	exit
	}

minimal(){
	checkChaotic &&
	installDependencies &&
	xdg-user-dirs-update &&	xdg-user-dirs-gtk-update
	moveConfigs
	changeTheme
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
		mv -u ~/Pictures/Wallpapers1/* ~/Pictures/Wallpapers &&
		rm -rf ~/Pictures/Wallpapers1	
	else 
		mkdir ~/Pictures/Wallpapers &&
		git clone https://github.com/Totti786/Wallpapers.git ~/Pictures/Wallpapers1 &&
		mv -u ~/Pictures/Wallpapers1/* ~/Pictures/Wallpapers &&
		rm -rf ~/Pictures/Wallpapers1	
	fi
}

#---- TUI functions  ---------------------

Dialog="dialog"

menu(){
	if $Dialog --yesno "$1" 20 60 ;then
		$2
	else
		$3
	fi
	}

progressBar(){
	for i in `seq 1 100`;do
	date +"`printf $i $i`"
	sleep .0005
	done | $Dialog --gauge "$1" 20 60 0
	}

additionalPrograms(){
	if $Dialog --yesno "Do you want to select wich additional apps you want to install?\n	
		Seleceting \"No\" will install all the additional apps" 20 60 ;then
	  	progs=$($Dialog --no-items --checklist "Choose the programs you want installed:"  20 60 12 \
		$(for app in $(cat $DIR/deps/extra.txt); do	echo "$app" off ;done) \
		2>&1 >/dev/tty) &&
		sudo pacman -Sy $progs --needed
	else
		sudo pacman -Sy - < $DIR/deps/extra.txt --needed
	fi
}

update(){
	progressBar "Updating... "
	installDependencies
	sudo cp -r $DIR/bin/bin/ /usr/local/ 
	cp -r $DIR/bin/.scripts/ ~/ 
	cp -r $DIR/cfg/* ~/.config 
	cp -r $DIR/bin/.local/ ~/
	papirus-folders -R
	feh --no-fehbg --bg-fill $DIR/deps/background.jpg
	}

install(){
	installOptions=$($Dialog --radiolist  "Choose one of the following options:"  15 60 4\
		minimal "Minimal Install" off\
		zsh "Zsh Configuration" off\
		sddm "SDDM Theme" off\
		grub "Grub Theme" off\
		wpgtk "Generate color-schemes from wallpapers" off\
		2>&1 >/dev/tty)
	$installOptions
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
			update
			main		
			;;
		4)
			wallpapers
			main
			;;
		5)
			git pull
			main
			;;
		6)
			exit
			;;
	esac
}

if command -v $Dialog &> /dev/null; then 
	main
else 
	sudo pacman -S $Dialog &&
	main
fi

