# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/.scripts/
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
	git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

export VISUAL='geany'
export EDITOR='vim'
export TERMINAL='alacritty'
export BROWSER='firefox'
export HISTORY_IGNORE="(ls|cd|cls|clear|pwd|exit|sudo reboot|history|cd -|cd ..)"

# ls
alias l='ls -lh'
alias ll='ls -lah'
alias la='ls -A'
alias lm='ls -m'
alias lr='ls -R'
alias lg='ls -l --group-directories-first'

# git
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push origin master'

#pacman 
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -Rcns'
alias pacu='sudo pacman -Syu'
alias pacc='sudo pacman -Sc'

#misc
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias neo='neofetch'
alias edit='vim ~/.zshrc'
alias ctemp='watch -n 1 sensors'
alias cls='clear'
