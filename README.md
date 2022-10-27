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
| [`Font Awesome`](https://github.com/FortAwesome/Font-Awesome)                                            | Primary Icon Font   |
| [`Phoshphor Icons`](https://github.com/phosphor-icons/phosphor-icons/blob/master/src/fonts/Phosphor.ttf) | Secondary Icon Font |

## :gear: Configuration


## :pushpin: Dependencies

#### Packages

:warning: **The following instructions have only been written for arch-based distros**
Install an [AUR helper](https://wiki.archlinux.org/title/AUR_helpers) of your choice

- Using the [yay](https://github.com/Jguer/yay#installation) helper

```bash
yay -S --needed \
sxhkd bspwm alacritty zsh neovim polybar stalonetray \
plank dunst rofi jgmenu xprintidle i3lock-color zathura \
broot fzf mpv neofetch ranger ueberzug xdo perl cava \
xbanish xss-lock pavucontrol nitrogen flameshot exa bat copyq \
maim ant-dracula-kvantum-theme-git ant-dracula-theme-git \
papirus-icon-theme kvantum pacman-contrib xorg-xbacklight \
imagemagick
```

## :sparkles: Credits

- Excellent neovim config by [NvChad](https://github.com/NvChad/NvChad)
