# Totti786's dotfiles

You are expected to have a basic understanding of the unix system. If you are new to linux, please visit [here](https://linuxjourney.com/lesson/the-shell) or look for similar resources online. Do **NOT** proceed

- [Information](#information)
- [Specifications](#specifications)
- [Fonts](#fonts)
- [Configuration](#configuration)
- [Dependencies](#dependencies)
  - [Packages](#packages)
- [Credits](#credits)

## Information

My configuration is personalized to utilize keyboard shortcuts as well as mouse actions to keep my workflow meaningful and flexible under varying conditions.

<details close>
  <summary><b>Before proceeding</b></summary>
  
  - This readme is still a work in progress. Please open an issue for queries beyond its scope
  - All the visual config parameters have been written for a [resolution](https://wiki.archlinux.org/title/Xrandr) of 1920x1080 pixels
  - Non GUI apps will need to be configured manually to be correctly displayed in lower/higher resolutions
  - Please read the [man-page](https://wiki.archlinux.org/title/Man_page) for an app before asking specific questions not addressed here

</details>

## Specifications

| Feature                | Package                                                 |
| --------------------   | ------------------------------------------------------- |
| Floating Window Manager| [`openbox`](https://github.com/danakj/openbox)          |
| Tiling Window Manager  | [`bspwm`](https://github.com/baskerville/bspwm)         |
| Tiling Window Manager  | [`i3`](https://github.com/i3/i3)					       |
| Hyprland Window Manager| [`Hyprland`](https://github.com/hyprwm/Hyprland)		   |
| Aylur's Gtk Shell		 | [`ags`](https://github.com/Aylur/ags)				   |
| Compositor             | [`picom`](https://github.com/yshui/picom)  			   |
| Terminal               | [`alacritty`](https://github.com/alacritty/alacritty)   |
| Shell                  | [`zsh`](https://www.zsh.org/)                           |
| Text Editor      		 | [`geany`](https://github.com/geany/geany)               |
| File Manager    		 | [`thunar`](https://github.com/xfce-mirror/thunar)       |
| Panel                  | [`polybar`](https://github.com/polybar/polybar)         |
| System Tray            | [`stalonetray`](https://github.com/kolbusa/stalonetray) |
| Dock                   | [`plank`](https://github.com/ricotz/plank)              |
| Widgets                | [`eww`](https://github.com/elkowar/eww)       	       |
| Notification Daemon    | [`dunst`](https://github.com/dunst-project/dunst)       |
| Application Launcher   | [`rofi-wayland`](https://github.com/lbonn/rofi)         |
| Right Click Menu       | [`jgmenu`](https://github.com/johanmalm/jgmenu)         |

## Fonts

| Font List																				| Use                 |
| ------------------------------------------------------------------------------------- | ------------------- |
| [`Noto Sans`](https://fonts.google.com/noto)											| GTK and QT Font     |
| [`JetBrainsMono Nerd Font`](https://github.com/jtbx/jetbrainsmono-nerdfont)			| Primary Font        |
| [`Material Symbols`](https://github.com/google/material-design-icons)					| Icons Font          |

## Configuration

## Scripted Install

In Progress...

## Manual Install

## Dependencies

These configs are tested on Arch Linux, with 1920x1080 resolution.

#### Packages

:warning: **The following instructions have only been written for arch-based distros**
Install an [AUR helper](https://wiki.archlinux.org/title/AUR_helpers) of your choice
You are required to have the [Chaotic-AUR](https://aur.chaotic.cx/) repo added on your system
- Using `yay` with the Chaotic-AUR enabled

```bash
yay -Syu --needed \
acpi acpilight alacritty appimagelauncher aur/qt5gtk2 aur/qt6gtk2 autotiling axel base-devel \
bc blueman bluez bluez-utils brightnessctl bspwm clight conky copyq dmenu drawing dunst \
envycontrol fd feh file-roller firefox flameshot fluent-cursor-theme-git font-manager fzf \
gammastep geany gnome-bluetooth-3.0 gnome-calculator gnome-disk-utility gnome-epub-thumbnailer \
gpick gpu-screen-recorder-git grep htop i3lock-color i3-resurrect i3-wm imagemagick jgmenu jq \
kdeconnect libplasma linux-wifi-hotspot man moreutils mpv mpv-mpris mugshot ncdu network-manager-applet \
networkmanager-openvpn noto-fonts noto-fonts-cjk noto-fonts-emoji nsxiv nvtop obconf openbox openssh \
openvpn paper papirus-icon-theme pastel pavucontrol perl picom-git plank plasma-browser-integration \
playerctl polkit-gnome polybar python-gtts python-materialyoucolor-git python-pipx python-wheel \
qbittorrent qt5ct rhythmbox rofi-wayland rtorrent ruby-fusuma ruby-fusuma-plugin-sendkey \
ruby-fusuma-plugin-wmctrl scrot sioyek-git snapshot stalonetray sxhkd termdown thunar \
thunar-archive-plugin thunar-media-tags-plugin thunar-volman timeshift translate-shell \
ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-material-symbols-variable-git ttf-nerd-fonts-symbols \
ttf-nerd-fonts-symbols-common tumbler viewnior waypaper-git wget wmctrl xcape xclip xdg-autostart \
xdg-user-dirs xdg-user-dirs-gtk xdo xdotool xfce4-power-manager xfce4-settings xiccd xorg-xdpyinfo \
xorg-xkill xorg-xrandr xorg-xrdb xorg-xsetroot xorg-xwininfo xqp xss-lock yad ytfzf zathura zathura-cb \
zathura-pdf-mupdf zenity zscroll-git zsh 

```
If you want to install hyprland configs to work, you need the following packages as well:

```bash
yay -Syu --needed \
aylurs-gtk-shell-git dart-sass gnome-control-center grim hypridle hyprland \
hyprlock aur/hyprpicker nwg-displays slurp swww ttf-readex-pro \
xdg-desktop-portal-hyprland python-pywayland wl-clipboard
```

## Credits
- [end-4](https://github.com/end-4) for his amazing ags configs
- [beyond9thousand](https://github.com/beyond9thousand) for his Readme and the system tray script idea
- [adi1090x](https://github.com/adi1090x) for his awesome rofi themes and some other scripts from Archcraft
- [vaxerski](https://github.com/vaxerski) for all of his awesome work on Hyprland
