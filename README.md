# Totti786's dotfiles

You are expected to have a basic understanding of the unix system. If you are new to linux, please visit [here](https://linuxjourney.com/lesson/the-shell) or look for similar resources online. Do **NOT** proceed

- [Information](#pencil-information)
- [Specifications](#mag-specifications)
- [Fonts](#ab-fonts)
- [Configuration](#gear-configuration)
- [Dependencies](#pushpin-dependencies)
  - [Packages](#packages)
- [Credits](#sparkles-credits)

## :pencil: Information

My configuration is personalized to utilize keyboard shortcuts as well as mouse actions to keep my workflow meaningful and flexible under varying conditions.

<details close>
  <summary><b>Before proceeding</b></summary>
  
  - This readme is still a work in progress. Please open an issue for queries beyond its scope
  - All the visual config parameters have been written for a [resolution](https://wiki.archlinux.org/title/Xrandr) of 1920x1080 pixels
  - Non GUI apps will need to be configured manually to be correctly displayed in lower/higher resolutions
  - Please read the [man-page](https://wiki.archlinux.org/title/Man_page) for an app before asking specific questions not addressed here

</details>

## :mag: Specifications

| Feature                | Package                                                 |
| --------------------   | ------------------------------------------------------- |
| Floating Window Manager| [`openbox`](https://github.com/danakj/openbox)          |
| Tiling Window Manager  | [`bspwm`](https://github.com/baskerville/bspwm)         |
| Compositor             | [`FT-labs's/picom`](https://github.com/FT-labs/picom)   |
| Terminal               | [`alacritty`](https://github.com/alacritty/alacritty)   |
| Shell                  | [`zsh`](https://www.zsh.org/)                           |
| Editor                 | [`neovim`](https://github.com/neovim/neovim)            |
| Panel                  | [`polybar`](https://github.com/polybar/polybar)         |
| System Tray            | [`stalonetray`](https://github.com/kolbusa/stalonetray) |
| Dock                   | [`plank`](https://github.com/ricotz/plank)              |
| Notification Manager   | [`dunst`](https://github.com/dunst-project/dunst)       |
| Application Launcher   | [`rofi`](https://github.com/davatorium/rofi)            |
| Application Menu       | [`jgmenu`](https://github.com/johanmalm/jgmenu)         |



## :ab: Fonts

| Font List                                                                                                | Use                 |
| -------------------------------------------------------------------------------------------------------- | ------------------- |
| [`Roboto`](https://github.com/googlefonts/roboto)                                                        | Primary Font        |
| [`JetBrainsMono Nerd Font`](https://github.com/jtbx/jetbrainsmono-nerdfont)                              | Primary UI Font     |

## :gear: Configuration


## :pushpin: Dependencies

#### Packages

:warning: **The following instructions have only been written for arch-based distros**
Install an [AUR helper](https://wiki.archlinux.org/title/AUR_helpers) of your choice
You are also required to have the Chaotic-AUR repo added on your system
- Using the [yay](https://github.com/Jguer/yay#installation) helper

```bash
yay -S --needed \
sxhkd bspwm alacritty zsh polybar stalonetray openbox obconf conky \
plank dunst rofi jgmenu grep i3lock-color zathura conky brightnessctl \
xcape mpv ranger xdo perl cava gpick geany thunar thunar-archive-plugin \
pavucontrol flameshot copyq fd feh playerctl  bluez-git coppyq dmenu \
maim xclip light qt5ct qt5-styleplugins redshift tumbler viewnior xorg-xkill\
xorg-xbacklight sxiv wmctrl xcape xdg-autostart xfce4-settings xfce4-power-manager\
imagemagick xorg-xrdb zathura zathura-cb zathura-pdf-mupdf
```

## :sparkles: Credits

- Excellent neovim config by [NvChad](https://github.com/NvChad/NvChad)
