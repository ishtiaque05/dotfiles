#!/bin/bash

URL=https://raw.githubusercontent.com/ishtiaque05/dotfiles/master/helpers/.cmd_helper
if [ -n "$ZSH_VERSION" ]; then
   # assume Zsh
   if grep -q .cmd_helper "$HOME/.zshrc"; then
      echo "Command helper already included"
   else
     wget_output=$(wget -q "$URL" -O $HOME/.cmd_helper)
     if [ $? -ne 0 ]; then
       echo "source $HOME/.cmd_helper" >> $HOME/.zshrc
     fi 
   fi
elif [ -n "$BASH_VERSION" ]; then
   # assume Bash
else
   # asume something else
fi

