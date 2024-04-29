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
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export HISTORY_IGNORE="(ls|cd|cls|clear|pwd|exit|sudo reboot|history|cd -|cd ..)"

# ls
alias l='ls -lh'
alias ll='ls -lah'
alias la='ls -A'
alias lm='ls -m'
alias lr='ls -R'
alias lg='ls -l --group-directories-first'

#alias cat='bat --color always --theme base16 --plain'

# git
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push origin master'

# pacman 
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -Rcns'
alias pacu='sudo pacman -Syu'

# pacman install
alias paci="yay -Slq | fzf --prompt='➜ ' --color=16 -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | awk \"{print \$2}\")' | xargs -ro yay -S --needed"

# pacman remove
alias pacrr="yay -Qq | fzf --prompt='➜ ' --color=16 -m --preview 'yay -Qi {1}' | xargs -ro yay -Rns"

# pacman view
alias pac="yay -Qq | fzf --prompt='➜ ' --color=16 -m --preview 'yay -Qi {1}'"

# pacman clear
alias pacc='yay -Qtdq | yay -Rns -'

# misc
alias neo='neofetch'
alias edit='vim ~/.zshrc'
alias ctemp='watch -n 1 sensors'
alias cls='clear'
