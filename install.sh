#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

# Check if script is run as root
if [[ "$(id -u)" -eq 0 ]]; then
  echo "This script must not be run as root"
  exit 1
fi

#---- Core functions ---------------------

checkrepo(){
	chaotic="$(grep -i "chaotic" /etc/pacman.conf | head -n1)"
	if [[ "$chaotic" == "[chaotic-aur]" ]]; then 
		echo "The Chaotic AUR repo is already added"
	else
		echo "Adding the Chaotic AUR repo"
		# Import and sign Chaotic AUR repository key
		sudo pacman-key --recv-key "FBA220DFC880C036" --keyserver keyserver.ubuntu.com || exit 1
		sudo pacman-key --lsign-key "FBA220DFC880C036" || exit 1
		
		# Add Chaotic AUR repository to pacman.conf
		sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm || exit 1 &&
		echo "[chaotic-aur]
		Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
		
		# Configure pacman
		sudo sed -i -e "s/#ParallelDownloads = .*/ParallelDownloads = 10/g" /etc/pacman.conf
		sudo sed -i -e "s/#Color/Color/g" /etc/pacman.conf
	fi
	
	if ! pacman -Q yay &> /dev/null; then 
		echo "Installing the AUR helper yay..."
		sudo pacman -Sy yay --noconfirm
	else
		echo "The AUR helper yay is already installed"
	fi
	}

install_minimal(){
	sudo pacman -Syu $(cat "$DIR"/deps/minimal.txt) --needed --noconfirm
	sudo pacman -U "$DIR"/deps/packages/*.zst --needed --noconfirm
	}
	
install_full(){
	sudo pacman -Syu $(cat "$DIR"/deps/minimal.txt) --needed --noconfirm
	sudo pacman -U "$DIR"/deps/packages/*.zst --needed --noconfirm
	sudo pacman -U "$DIR"/deps/packages/additional/*.zst --needed --noconfirm
	#yay -S $(cat additional.txt) --needed --noconfirm
	}

minimal_install(){
	checkrepo &&
	install_minimal &&
	xdg-user-dirs-update &&	xdg-user-dirs-gtk-update
	moveConfigs
	sh "$DIR/bin/.scripts/file-check"
	changeTheme
	install_wpgtk
	}

full_install(){
	#checkrepo &&
	install_full
	xdg-user-dirs-update &&	xdg-user-dirs-gtk-update
	moveConfigs
	sh "$DIR/bin/.scripts/file-check"
	changeTheme
	install_sddm
	install_grub
	install_zsh
	install_wpgtk
	}

moveConfigs(){
	cp -r "$DIR"/bin/.scripts/ "$HOME" && echo "moved scripts home"
	cp -r "$DIR"/cfg/* "$HOME"/.config && echo "moved config files"
	cp -r "$DIR"/bin/.local/ "$HOME" && echo "moved bin"
	cp -r "$DIR"/deps/.zprofile "$HOME"
	
    mkdir -p "$HOME/.local/share/icons"
    mkdir -p "$HOME/.local/share/fonts"
    
    #tar -xf "$DIR"/deps/Papirus-icons.tar.gz -C "$HOME/.local/share/icons"
	tar -xf "$DIR"/deps/fonts.tar.gz -C "$HOME/.local/share/fonts"
	}
	
changeTheme(){
	if ! [[ "$(grep -i "qt5ct" /etc/environment | head -n1)" == "QT_QPA_PLATFORMTHEME=\"qt5ct\"" ]]; then
		echo "QT_QPA_PLATFORMTHEME=\"qt5ct\"" | sudo tee -a /etc/environment > /dev/null
	fi
	xfconf-query -c xsettings -p /Net/ThemeName -s "FlatColor"
	xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"	
	cat "$DIR/cfg/plank/plank.conf" | dconf load /net/launchpad/plank/docks/
	cp -r "$DIR"/bin/.icons "$HOME"
	
	if [[ -d  /usr/share/icons/Papirus ]]; then 
		sudo chgrp -R $(whoami) /usr/share/icons/Papirus
		sudo chmod -R ug+rwX /usr/share/icons/Papirus
		sudo ln -s /usr/share/icons/Papirus-Dark "$HOME"/.local/share/icons/Papirus
	fi
	}

install_wpgtk(){
	sh "$DIR"/bin/.local/bin/wpgtk run &&
	if $Dialog --yesno "Do you want your Login Screen background to sync with your wallpaper? 
			(This only works with the included SDDM theme)" 20 60 ;then
		sh "$DIR"/bin/.local/bin/wpgtk lockPerms &&
		sh "$DIR"/bin/.local/bin/wpgtk wall "$DIR"/deps/background.jpg 
	else
		sh "$DIR"/bin/.local/bin/wpgtk wall "$DIR"/deps/background.jpg
	fi
	}

#---- Additional configurations ----------

install_zsh(){
	# Check and set Zsh as the default shell
	[[ "$(awk -F: -v user="$USER" '$1 == user {print $NF}' /etc/passwd) " =~ "zsh " ]] || chsh -s $(which zsh)
	
	# Install Oh My Zsh
	if [ ! -d "$HOME"/.oh-my-zsh/ ]; then
	  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 
	else
	  omz update
	fi
	
	# Install Zsh plugins
	[[ "${plugins[*]} " =~ "zsh-autosuggestions " ]] || git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	[[ "${plugins[*]} " =~ "zsh-syntax-highlighting " ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	
	cp "$DIR"/deps/.zshrc "$HOME"
	}
	
install_sddm(){
	# Check if SDDM is installed and install if not
	echo "Making sure that SDDM is installed"
	sudo pacman -S sddm plasma-framework --needed --noconfirm
	
	# Move sddm theme files
	if [ ! -d "/usr/share/sddm/themes/Chili" ]; then  
		sudo cp -R "$DIR"/deps/Chili  /usr/share/sddm/themes/
	fi
	
	cp "$DIR"/deps/.face "$HOME"
	
	# Create the directory for the sddm configuration files
	sudo mkdir -p "/etc/sddm.conf.d/"
	
	# Write the sddm theme configuration to a file
	# Redirect output to /dev/null to hide any console output
	# Use a heredoc to specify the configuration text
	sudo tee "/etc/sddm.conf.d/theme.conf" > /dev/null <<-EOF
	[Theme]
	Current=Chili
	CursorTheme=Fluent-dark-cursors
	DisableAvatarsThreshold=3
	EnableAvatars=true
	FacesDir=/usr/share/sddm/faces
	Font="JetBrains"
	ThemeDir=/usr/share/sddm/themes
	EOF
	
	# Disable currently enabled display manager
	if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
	  echo "Disabling currently enabled display manager"
	  sudo systemctl disable $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}')
	fi
	
	# Enable and start SDDM
	echo "Enabling SDDM"
	sudo systemctl enable sddm

	}
	
install_grub(){
	cd "$DIR"/deps/grub && sudo sh grub.sh && cd "$DIR"
	}

# Update or clone the wallpapers repository
wallpapers() {
    if [[ -d "$HOME/Pictures/Wallpapers/Wallpapers.git" ]]; then
        cd "$HOME/Pictures/Wallpapers/Wallpapers.git" && git pull
    else
        mkdir -p "$HOME/Pictures/Wallpapers"
        git clone --depth 1 https://github.com/Totti786/Wallpapers.git "$HOME/Pictures/Wallpapers/Wallpapers.git"
    fi
    
    # Check if the operation was successful and report any errors
    if [[ $? -eq 0 ]]; then
        echo "Wallpapers updated successfully."
    else
        echo "Wallpapers update failed. Please check your internet connection and try again."
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

tools(){
	installOptions=$($Dialog --radiolist  "Choose one of the following options:"  15 60 4\
		checkrepo "Add Chaotic AUR repo" off\
		install_full "Install Dependencies" off\
		install_zsh "Zsh Configuration" off\
		install_sddm "SDDM Theme" off\
		install_grub "Grub Theme" off\
		install_wpgtk "Generate color-schemes from wallpapers" off\
		2>&1 >/dev/tty)
	$installOptions		
	}


update(){
	## update dependencies and install new ones
	install_minimal
	progressBar "Updating... "
	## backup weather info file
	[ -f "$HOME/.config/polybar/scripts/info" ] &&
		cp "$HOME"/.config/polybar/scripts/info "$HOME"/.cache/info
	#[ ! -f "$HOME/.zprofile" ] && 
	cp	"$DIR"/deps/.zprofile "$HOME"/
	## move udpated scripts and configs
	cp -r "$DIR"/bin/.scripts/ "$HOME"/ 
	cp -r "$DIR"/cfg/* "$HOME"/.config/
	cp -r "$DIR"/bin/.local/ "$HOME"/
	# restore weather info file
	cp "$HOME"/.cache/info "$HOME"/.config/polybar/scripts/info
	sh "$DIR/bin/.scripts/file-check"
	}

install_menu(){
	local OPTIONS=(1 "Install essential programs and configs"
				   2 "Install with optional utilities, and (zsh,sddm,grub) themes"
				   3 "Exit")
	local CHOICE=$($Dialog --clear \
	                --title "Install Script" \
	                --menu "Choose one of the following options:" \
	                10 80 4 \
	                "${OPTIONS[@]}" \
	                2>&1 >/dev/tty)
	case $CHOICE in
		1)
			minimal_install
			;;
		2)
			full_install
			;;
		3)
			clear
			exit
			;;
	esac
	}

main(){
	local OPTIONS=(1 "Install"
	         2 "Install Additional Packages"
	         3 "Update"
	         4 "Download Wallpapers"
	         5 "Update Script"
	         6 "Tools"
	         7 "Exit")
	
	local CHOICE=$($Dialog --clear \
	                --title "Install Script" \
	                --menu "Choose one of the following options:" \
	                15 40 4 \
	                "${OPTIONS[@]}" \
	                2>&1 >/dev/tty)
	clear
	
	case $CHOICE in
		1)
			install_menu &&
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
			"$DIR"/install.sh
			;;
		6)
			tools
			;;
		7)
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
