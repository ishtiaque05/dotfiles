#!/bin/bash

URL=https://raw.githubusercontent.com/ishtiaque05/dotfiles/master/helpers/.cmd_helper
if [[ $SHELL == *"zsh"* ]]; then
   # assume Zsh

   if grep -q .cmd_helper $HOME/.zshrc
   then
      echo "Command helper already included"
   else
     wget_output=$(wget -q "$URL" -O $HOME/.cmd_helper)
     if [[ "$?" == 0 ]]; then
       echo "source $HOME/.cmd_helper" >> $HOME/.zshrc
       echo "Added .cmd_helper as source to ~/.zshrc"
     fi
   fi
elif [[ $SHELL == *"bash"* ]]; then
   # assume Bash
   # asume something else
   echo "Bash file"
fi

