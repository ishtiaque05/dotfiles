#!/usr/bin/env bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green


if [[ -d ~/.config/nvim/autoload/plug.vim ]]; then
  echo -e "$RED ########## Vim-plug already installed. Skipping ... $Color_Off"
else
  echo -e "$Green ########## Installing vim-plug ... $Color_Off"
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  which nvim > /dev/null && nvim +PlugUpgrade +PlugUpdate +PlugClean +qa
fi

