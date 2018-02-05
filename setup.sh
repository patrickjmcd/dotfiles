#!/bin/bash

brewcask_check(){
  pkg=$1
  if [ -z "$pkg" ]                           # Is parameter #1 zero length?
    then
      echo "No package name passed to brewcask_check"  # Or no parameter passed.
    else
      if [ -z "$(brew cask ls --versions $pkg)" ]
      then
        echo "brew cask install $pkg"
        brew cask install $pkg
      else
        echo "brew cask upgrade $pkg"
        brew cask upgrade $pkg
      fi
  fi
}

brew_check(){
  pkg=$1
  if [ -z "$pkg" ]                           # Is parameter #1 zero length?
    then
      echo "No package name passed to brew_check"  # Or no parameter passed.
    else
      if [ -z "$(brew ls --versions $pkg)" ]
      then
        echo "brew install $pkg"
        brew install $pkg
      else
        echo "brew upgrade $pkg"
        brew upgrade $pkg
      fi
  fi
}

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

  # Install or update Homebrew Cask
  if [[ ! -d /usr/local/Caskroom ]]; then
      # unless user specified another location, they do not have Cask. Just try to install it, nothing will break
      echo "Installing Cask..."
      brew tap caskroom/cask
  else
      echo "Updating Cask..."
      brew update
  fi

  # Spectacle
  # keyboard-friendly window management
  brewcask_check spectacle

  # iTerm2
  # better[citation needed] terminal application
  brewcask_check iterm2

  # tmux
  #  terminal manager--no need for GUI terminal tabs anymore,
  #  group terminals by project, connect to existing terms from
  #  other windows, all kinds of fun stuff
  brew_check tmux

  # Atom
  #  Text editor.
  # Alternative:
  #brew cask install sublime-text
  brewcask_check atom

  # Firefox
  #  Browser
  brewcask_check firefox

  # Chrome
  #  Browser
  brewcask_check google-chrome

  # zsh
  #  alternative shell, like bash but more awesome
  brew_check zsh

  # gpg
  #  GnuPG
  brew_check gpg


  # virtualbox
  #  for virtual machines
  brewcask_check virtualbox

  # vagrant
  #  command line management and provisioning of headless Virtualbox VMs
  brewcask_check vagrant

  # boot2docker^wdocker-machine
  #  run docker containers in a local VM using ordinary docker commands
  #brew install boot2docker
  brew_check docker-machine

  # Heroku toolbelt
  #  command line tool for Heroku
  brew_check heroku

  # RVM
  #  keep your rubies from stepping on one another
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  \curl -sSL https://get.rvm.io | bash -s stable

  # emacs
  #  text editor
  brew_check emacs

  # github client
  #  gui github client; handy for some stuff even if you prefer git on the command line
  brewcask_check github

  # wget
  #  command line http file downloader. I always forget this isn't installed by default.
  brew_check wget

  # docker-compose (fig)
  #  manage sets of docker containers
  brew_check docker-compose

  # postgres
  #  required to build Ruby postgresql gem
  brew_check postgres

  # node
  #  NodeJS. Pretty much unavoidable.
  brew_check node

  # nvm
  #  Like RVM but Webscale™. (rvm for node)
  brew_check nvm

  # tree
  brew_check tree

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

  # RVM
  #  keep your rubies from stepping on one another
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  \curl -sSL https://get.rvm.io | bash -s stable

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


combined_setup() {
    echo "Switching to zsh..."
    zsh

    # go home
    echo "Going home..."
    cd ~

    # install global node modules
    echo "Installing n and trash-cli..."
    npm install --global n trash-cli spaceship-prompt

    # install global pip submodules
    echo "Installing python modules"
    pip install speedtest-cli

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

    echo "Moving to home to continue"
    cd ~

    # symlink ~/github/dotfiles to ~/dotfiles to make it easier to manage
    # we want all our version controlled configs in ~/dotfiles.
    echo "Setting up symlinks..."
    ln -s ~/github/dotfiles ~/.dotfiles

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

    if [ -f ~/.hyperterm.js ]; then
        echo "Overriding .hyperterm.js..."
        mv ~/.hyperterm.js ~/.hyperterm.js.bak
    fi

    # if they have a .zshrc, kill it
    echo "Backup any existing .zshrc config..."
    mv ~/.zshrc ~/.zshrc.bak
    mv ~/.zpreztorc ~/.zpreztorc.bak
    mv ~/.zshenv ~/.zshenv.bak
    mv ~/.zlogin ~/.zlogin.bak
    mv ~/.zlogout ~/.zlogout.bak
    rm -rf ~/.zprezto

    # # zpresto
    echo "Cloning prezto"
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    echo "Symlinking new config files"
    ln -s "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zlogin "${ZDOTDIR:-$HOME}"/.zlogin
    ln -s "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zlogout "${ZDOTDIR:-$HOME}"/.zlogout
    # ln -s "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc "${ZDOTDIR:-$HOME}"/.zpreztorc
    ln -s "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zshenv "${ZDOTDIR:-$HOME}"/.zshenv
    ln -s "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zshrc "${ZDOTDIR:-$HOME}"/.zshrc

    ln -s ~/.dotfiles/.hyperterm.js ~/.hyperterm.js
    ln -s ~/.dotfiles/.zpreztorc ~/.zpreztorc

    # let them know what to do
    echo "All done! Open a new tab or window to start using your new config."
}


platform="$(uname | tr '[:upper:]' '[:lower:]')"
if [[ "$platform" == "linux" ]]; then
  echo "Setting up everything for Linux"
  aptget_setup
  combined_setup
elif [[ "$platform" == "darwin" ]]; then
  echo "Setting everything up for macOS..."
  # in case we are in bash
  #
  brew_setup
  combined_setup
fi
