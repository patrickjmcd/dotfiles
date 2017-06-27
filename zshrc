# Path to your oh-my-zsh installation.
export ZSH=/Users/patrickjmcd/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

plugins=(git brew python docker pip tmux aws osx)

source $ZSH/oh-my-zsh.sh

# use z for better fuzzy searching
if [[ -s ~/z/z.sh ]]; then
	source ~/z/z.sh
fi

# source aliases
if [[ -f ~/dotfiles/.aliases ]]; then
  source ~/dotfiles/.aliases
fi

# source functions
if [[ -f ~/dotfiles/.functions ]]; then
  source ~/dotfiles/.functions
fi
