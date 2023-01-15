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
| Compositor             | [`FT-labs's/picom`](https://github.com/FT-labs/picom)   |
| Terminal               | [`alacritty`](https://github.com/alacritty/alacritty)   |
| Shell                  | [`zsh`](https://www.zsh.org/)                           |
| Terminal Editor        | [`neovim`](https://github.com/neovim/neovim)            |
| GUI Editor      		 | [`geany`](https://github.com/geany/geany)               |
| File Manager    		 | [`thunar`](https://github.com/xfce-mirror/thunar)       |
| Panel                  | [`polybar`](https://github.com/polybar/polybar)         |
| System Tray            | [`stalonetray`](https://github.com/kolbusa/stalonetray) |
| Dock                   | [`plank`](https://github.com/ricotz/plank)              |
| Widgets                | [`eww`](https://github.com/elkowar/eww)              |
| Notification Manager   | [`dunst`](https://github.com/dunst-project/dunst)       |
| Application Launcher   | [`rofi`](https://github.com/davatorium/rofi)            |
| Application Menu       | [`jgmenu`](https://github.com/johanmalm/jgmenu)         |



## Fonts

| Font List                                                                                                | Use                 |
| -------------------------------------------------------------------------------------------------------- | ------------------- |
| [`Noto Sans`](https://fonts.google.com/noto)                                                       	   | GTK and QT Font        |
| [`JetBrainsMono Nerd Font`](https://github.com/jtbx/jetbrainsmono-nerdfont)                              | Primary Font     |

## Configuration


## Dependencies

#### Packages

:warning: **The following instructions have only been written for arch-based distros**
Install an [AUR helper](https://wiki.archlinux.org/title/AUR_helpers) of your choice
You are also required to have the Chaotic-AUR repo added on your system
- Using the [yay](https://github.com/Jguer/yay#installation) helper

```bash
sudo pacman -Syu --needed \
acpi alacritty bc bluez-git brightnessctl bspwm conky \
copyq dmenu dunst fd feh firefox flameshot geany gpick \
grep htop i3lock-color imagemagick jgmenu light maim man \
moreutils mpv mpv-mpris mugshot ncdu network-manager-applet \
networkmanager-openvpn noto-fonts noto-fonts-emoji obconf openbox \
pavucontrol perl plank playerctl polybar qt5ct qt5-styleplugins \
ranger redshift rofi stalonetray sxhkd sxiv thunar tumbler viewnior \
wget wmctrl xarchiver xcape xclip xdg-autostart xdg-user-dirs \
xdg-user-dirs-gtk xdotool xfce4-power-manager xfce4-settings \
xorg-xkill xorg-xrdb xorg-xsetroot zathura zathura-cb \
zathura-pdf-mupdf zenity zsh
```

## Credits
- [beyond9thousand](https://github.com/beyond9thousand) for his Readme and the system tray
- [adi1090x](https://github.com/adi1090x) for his awesome rofi themes and some other scripts from Archcraft
