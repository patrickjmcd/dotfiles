#
# Makefile for dotfiles
#
# This file can be used to install individual dotfiles or 
# all of them at once. Each Makefile rule will clean the
# existing dotfile and creating a new symlink.
#


help:
	@echo 'Makefile for dotfiles'
	@echo ''
	@echo 'Usage:'
	@echo '     make all					install everything'


BREW := $(shell command -v brew 2> /dev/null)
OS := $(shell uname)
DOTFILE_FOLDER := ~/.dotfiles

all:
ifeq ($(OS),Darwin)
	@echo "Running Makefile for MacOS"
	$(MAKE) brew_setup
else
	@echo "Running Makefile for apt- based systems"
	$(MAKE) aptget_setup
endif 
	$(MAKE) non_os_specific

non_os_specific: nodepackage_setup pythonpackage_setup dotfiles git vscode_extensions hyper zsh

brew_setup: 
ifndef BREW
	@echo "Installing Homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	@echo "Installing Homebrew Bundle"
	brew tap Homebrew/bundle
	@echo "Installing applications via Homebrew and Cask..."
	brew bundle
endif
	@echo 'Updating brew'
	brew update
	

aptget_setup:
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install apt-transport-https git build-essential nodejs tmux zsh gpg virtualbox vagrand docker-machine docker-compose heroku github wget tree code gdebi zsh
	wget https://hyper-updates.now.sh/download/linux_deb
	sudo gdebi linux_deb

nodepackage_setup: 
	@echo 'Setting up packages for node'
	npm install -g typescript prettier create-react-app create-react-native-app yarn
	yarn install

pythonpackage_setup:
	@echo 'Setting up packages for python'
	pip install speedtest-cli virtualenv

dotfiles:
	@echo 'symlinking $(DOTFILE_FOLDER)'
ifneq ($(wildcard ~/.gitignore_global),)
	ln -s ~/github/dotfiles $(DOTFILE_FOLDER)
endif 
	

git_backup:
	@echo 'Backing up gitignore'
ifneq ($(wildcard ~/.gitignore_global),) 
	mv ~/.gitignore_global ~/.gitignore_global.bak
endif 
	@echo 'Backing up gitconfig'
ifneq ($(wildcard ~/.gitconfig),) 
	mv ~/.gitconfig ~/.gitconfig.bak
endif
	

git: git_backup
	@echo 'Setting up gitignore'
ifneq ($(wildcard $(DOTFILE_FOLDER)/.gitignore_global),) 
	ln -s $(DOTFILE_FOLDER)/.gitignore_global ~/.gitignore_global
endif 
	@echo 'Setting up gitconfig'
ifneq ($(wildcard $(DOTFILE_FOLDER)/.gitignore_global),) 
	ln -s $(DOTFILE_FOLDER)/.gitconfig ~/.gitconfig
endif 

vscode_extensions:
	$(SHELL) vscode.sh

hyper_backup:
	@echo 'Backing up hyper'
ifneq ($(wildcard ~/.hyper.js),) 
	mv ~/.hyper.js ~/.hyper.js.bak
endif 

hyper: hyper_backup
	@echo 'Setting up hyper'
ifneq ($(wildcard $(DOTFILE_FOLDER)/.hyper.js),) 
	ln -s $(DOTFILE_FOLDER)/.hyper.js ~/.hyper.js
endif 

zsh_backup:
	@echo 'Backing up zsh'
ifneq ($(wildcard ~/.zshrc),) 
	mv ~/.zshrc ~/.zshrc.bak
endif 
ifneq ($(wildcard ~/.zpreztorc),) 
	mv ~/.zpreztorc ~/.zpreztorc.bak
endif 
ifneq ($(wildcard ~/.aliases),) 
	mv ~/.aliases ~/.aliases.bak
endif 
ifneq ($(wildcard ~/.functions),) 
	mv ~/.functions ~/.functions.bak
endif
ifneq ($(wildcard ~/.zprezto/README.md),) 
	rm -rf ~/.zprezto
endif


zsh: zsh_backup 
	git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
	chsh -s /bin/zsh
ifneq ($(wildcard $(DOTFILE_FOLDER)/.zshrc),) 
	ln -s $(DOTFILE_FOLDER)/.zshrc ~/.zshrc
endif
ifneq ($(wildcard $(DOTFILE_FOLDER)/.zpreztorc),) 
	ln -s $(DOTFILE_FOLDER)/.zpreztorc ~/.zpreztorc
endif 
ifneq ($(wildcard $(DOTFILE_FOLDER)/.aliases),) 
	ln -s $(DOTFILE_FOLDER)/.aliases ~/.aliases
endif
ifneq ($(wildcard $(DOTFILE_FOLDER)/.functions),) 
	ln -s $(DOTFILE_FOLDER)/.functions ~/.functions
endif 


