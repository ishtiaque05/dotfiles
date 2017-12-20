#!/usr/bin/env bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green

if which nvim > /dev/null; then
 echo -e "$Red ######### nvim already installed skipping......... $Color_Off"
else
 echo -e "$Green ######## installing nvim..................... $Color_Off"
 sudo apt-get install python-dev python-pip python3-dev python3-pip -y
 sudo add-apt-repository ppa:neovim-ppa/stable
 sudo apt-get update
 sudo apt-get install neovim -y
fi

