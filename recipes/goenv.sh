#!/usr/bin/env bash

if which git > /dev/null; then
  git clone https://github.com/syndbg/goenv.git ~/.goenv && 
  echo 'export GOENV_ROOT="$HOME/.goenv"' >> ~/.zshenv &&
  echo 'eval "$(goenv init -)"' >> ~/.zshenv
else
  echo 'Git not installed run sudo apt-get install git'
fi

# goenv install 1.6.2
# goenv global 1.6.2
# goenv local 1.6.2
