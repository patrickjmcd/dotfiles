#!/bin/bash
echo "Setting everything up from the Github Repo"
mkdir -p ~/github
git clone https://github.com/patrickjmcd/dotfiles ~/github/dotfiles
cd ~/github/dotfiles
make all
