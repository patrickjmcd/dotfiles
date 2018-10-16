# use z for better fuzzy searching
if [[ -s ~/z/z.sh ]]; then
	source ~/z/z.sh
fi

# source aliases
if [[ -f ~/.dotfiles/.aliases ]]; then
  source ~/.dotfiles/.aliases
fi

# source functions
if [[ -f ~/.dotfiles/.functions ]]; then
  source ~/.dotfiles/.functions
fi

# source environment variables
if [[ -f ~/.env_variables ]]; then
  source ~/.env_variables
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export PATH=$PATH:~/go/bin
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
/etc/motd
