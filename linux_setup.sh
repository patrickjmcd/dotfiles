#!/bin/bash

echo "Setting up everything for Linux"

echo "Lets first make sure our package list is up to date"
sudo apt-get update

echo "Remove some stupid packages that aren't needed"
sudo apt-get -y remove --purge minecraft-pi python-minecraftpi wolfram-engine sonic-pi scratch nuscratch libreoffice
sudo apt-get -y autoremove

echo "Upgrade any packages that are out of date"
sudo apt-get -y upgrade

echo "Installing zsh & tmux"
sudo apt-get install -y zsh tmux

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
ln -s ~/dotfiles/.gitconfig ~/.gitconfig

if [ -f ~/.zshrc ]; then
    echo "Overriding .zshrc..."
    rm ~/.zshrc
fi
ln -s ~/dotfiles/zshrc ~/.zshrc

echo "Installing nvm and node"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node

echo "Installing python versions"
sudo apt-get install -y python python-pip python3 python3-pip

echo "Installing RVM and Ruby"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /home/patrickjmcd/.rvm/scripts/rvm
rvm install ruby --latest
gem install rails


# in case we are in bash...
echo "Changing shell to zsh..."
chsh -s /bin/zsh

# don't make me wait! I want to use this ASAP
echo "Sourcing .zshrc..."
source ~/.zshrc

# let them know what to do
echo "All done! Open a new tab or window to start using your new shell."
