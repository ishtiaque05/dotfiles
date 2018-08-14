#!/usr/bin/env bash

echo -e "  \033[94m ==> \033[39m"
echo -e "  \033[94m ==> \033[32mInstalling zplug for zsh \033[39m"
if [ -d $HOME/.zplug ]; then
  echo -e "  \033[94m ==> \033[33mzplug already installed. Skipping... \033[39m"
else
  git clone https://github.com/zplug/zplug.git ${HOME}/.zplug
fi
