#!/bin/bash

brew_setup(){

  # install or update Homebrew
  echo "Checking for existing Homebrew installation..."
  which -s brew
  if [[ $? != 0 ]] ; then
      echo "Installing Homebrew..."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
      echo "Updating Homebrew..."
      brew update
  fi

  # Install Homebrew Bundle
  echo "Installing Homebrew Bundle"
  brew tap Homebrew/bundle

  # install homebrew applications
  echo "Installing applications via Homebrew and Cask..."
  cd ~/github/dotfiles
  brew bundle

}

aptget_setup(){
  sudo apt-get update
  sudo apt-get upgrade

  # tmux
  #  terminal manager--no need for GUI terminal tabs anymore,
  #  group terminals by project, connect to existing terms from
  #  other windows, all kinds of fun stuff
  sudo apt-get install tmux

  # Atom
  #  Text editor.
  # Alternative:
  #brew cask install sublime-text
  sudo apt-get install atom

  # zsh
  #  alternative shell, like bash but more awesome
  sudo apt-get install zsh

  # gpg
  #  GnuPG
  sudo apt-get install gpg


  # virtualbox
  #  for virtual machines
  sudo apt-get install virtualbox

  # vagrant
  #  command line management and provisioning of headless Virtualbox VMs
  sudo apt-get install vagrant

  # boot2docker^wdocker-machine
  #  run docker containers in a local VM using ordinary docker commands
  #brew install boot2docker
  sudo apt-get install docker-machine

  # Heroku toolbelt
  #  command line tool for Heroku
  sudo apt-get install heroku

  # rbenv
  #  keep your rubies from stepping on one another
  sudo apt-get install rbenv

  # emacs
  #  text editor
  sudo apt-get install emacs

  # github client
  #  gui github client; handy for some stuff even if you prefer git on the command line
  sudo apt-get install github

  # wget
  #  command line http file downloader. I always forget this isn't installed by default.
  sudo apt-get install wget

  # docker-compose (fig)
  #  manage sets of docker containers
  sudo apt-get install docker-compose

  # postgres
  #  required to build Ruby postgresql gem
  sudo apt-get install postgres

  # node
  #  NodeJS. Pretty much unavoidable.
  sudo apt-get install node

  # nvm
  #  Like RVM but Webscale™. (rvm for node)
  sudo apt-get install nvm

  # tree
  sudo apt-get install tree
}

package_setup() {
  echo "Setting up packages for Node and Python"

  # install global node modules
  echo "Installing n and trash-cli..."
  npm install --global n trash-cli typescript

  # install global pip submodules
  echo "Installing python modules"
  pip install speedtest-cli
}


combined_setup() {
    # go home
    echo "Going home..."
    cd ~

    # if they have a .config/fish, kill it
    echo "Removing any existing fish configuration..."
    rm -rf ~/.config/fish
    rm -rf ~/.config/fisherman

    # install node
    echo "Installing NodeJS"
    curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"

    # if ~/github does not exist, create it
    if [ ! -d ~/github ]; then
        echo "Creating ~/github..."
        mkdir ~/github
    fi

    # cd into ~/github to clone git repos
    echo "Heading over to ~/github to clone some repos..."
    cd ~/github

    # clone the repo to get all the dotfile goodness
    echo "Cloning dotfiles..."
    echo "git clone --recursive git@github.com:patrickjmcd/dotfiles.git dotfiles"
    git clone --recursive https://github.com/patrickjmcd/dotfiles.git dotfiles

    cd dotfiles
    platform="$(uname | tr '[:upper:]' '[:lower:]')"
    if [[ "$platform" == "linux" ]]; then
      echo "Setting up everything for Linux"
      aptget_setup
    elif [[ "$platform" == "darwin" ]]; then
      echo "Setting everything up for macOS..."
      brew_setup
    fi

    echo "Moving to home to continue"
    cd ~

    echo "Installing Fisherman"
    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

    # symlink ~/github/dotfiles to ~/dotfiles to make it easier to manage
    # we want all our version controlled configs in ~/dotfiles.
    echo "Setting up symlinks..."
    ln -s ~/github/dotfiles ~/.dotfiles
    ln -s ~/github/dotfiles/fish ~/.config/fish

    if [ -f ~/.gitconfig ]; then
        echo "Overriding .gitconfig..."
        mv ~/.gitconfig ~/.gitconfig.bak
    fi

    ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

    if [ -f ~/.gitignore_global ]; then
        echo "Overriding .gitignore_global..."
        mv ~/.gitignore_global ~/.gitignore_global.bak
    fi

    ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global

    if [ -f ~/.hyper.js ]; then
        echo "Overriding .hyper.js..."
        mv ~/.hyper.js ~/.hyper.js.bak
    fi
    ln -s ~/.dotfiles/.hyper.js ~/.hyper.js


    echo "Installing Atom Packages"
    apm install `cat apm_packages.list`

    echo "Installing VS Code Packages"
    ~/github/dotfiles/vscode.sh

    # add fish to our available list of shells we can use
    echo "Adding fish to list of available shells..."
    echo /usr/local/bin/fish | sudo tee -a /etc/shells

    # switch to fish! I wanna use this immediately!
    echo "Changing shell to fish..."
    chsh -s /usr/local/bin/fish
    
    # this only works once we have changed the shell to be fish.
    echo "Installing fisher plugins..."
    fisher
}

combined_setup
