#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

zsh(){
	if pacman -Q zsh &> /dev/null; then
		echo "zsh is installed"
		if [ ! -d $HOME/.oh-my-zsh ]; then
			git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
		fi
		if [ "$SHELL" == "/usr/bin/zsh" ]; then
			echo "zsh is your default shell" 
		else
			chsh -s $(which zsh) 
		fi &&
		cp -r $DIR/custom ~/.oh-my-zsh/ && echo "moved zsh custom files" &&
		git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 
		cp -r $DIR/.zshrc ~/ &&
		echo "Zsh should be working now" 
	else 
		echo "Zsh is not installed, installing..." 
		sudo pacman -S zsh 
		zsh
	fi
	}
zsh
