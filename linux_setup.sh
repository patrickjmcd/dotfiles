#!/bin/bash

echo "Setting up everything for Linux"
# in case we are in bash


echo "Lets first make sure our package list is up to date"
sudo apt-get update

echo "Installing zsh"
sudo apt-get install -y zsh

echo "Switching to zsh..."
zsh

# go home
echo "Going home..."
cd ~

# if they have a .zshrc, kill it
echo "Removing any existing .zshrc config..."
rm .zshrc

echo "Making sure git is installed.."
sudo apt-get install -y git

# try to install z
if [[ ! -d ~/z ]]; then
    echo "Installing z..."
    git clone https://github.com/rupa/z.git z
fi

# install tree
echo "Installing tree..."
sudo apt-get install -y tree

echo "Installing Oh My ZSH!"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

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
git clone https://github.com/patrickjmcd/dotfiles.git dotfiles

# symlink ~/github/dotfiles to ~/dotfiles to make it easier to manage
# we want all our version controlled configs in ~/dotfiles.
echo "Setting up symlinks..."
ln -s ~/github/dotfiles ~/dotfiles

if [ -f ~/.gitconfig ]; then
    echo "Overriding .gitconfig..."
    rm ~/.gitconfig
fi

if [ -f ~/.zshrc ]; then
    echo "Overriding .zshrc..."
    rm ~/.zshrc
fi
ln -s ~/dotfiles/zshrc ~/.zshrc

# in case we are in bash...
echo "Changing shell to zsh..."
chsh -s /bin/zsh

# don't make me wait! I want to use this ASAP
echo "Sourcing .zshrc..."
source ~/.zshrc

# let them know what to do
echo "All done! Open a new tab or window to start using your new shell."
