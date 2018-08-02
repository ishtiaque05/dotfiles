#!/usr/bin/env bash

echo -e "  \033[94m ==> \033[39m"
echo -e "  \033[94m ==> \033[32mInstalling antigen for zsh \033[39m"
if [ -d $HOME/.antigen ]; then
  echo -e "  \033[94m ==> \033[33mantigen already installed. Skipping... \033[39m"
else
  git clone https://github.com/zsh-users/antigen.git $HOME/.antigen --depth=1
fi
