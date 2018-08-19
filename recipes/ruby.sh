#!/usr/bin/env bash

set -e
set -o pipefail

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

# rbenv installation

echo "############### SETTING UP RBENV ########################"
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

echo "############## SETTING UP RUBY BUILD ####################"
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL


RUBY_VERSION=$(rbenv install -l | awk -F '.' '
   /^[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+[[:space:]]*$/ {
      if ( ($1 * 100 + $2) * 100 + $3 > Max ) { 
         Max = ($1 * 100 + $2) * 100 + $3
         LATEST_RUBY_VERSION=$0
         }
      }
END {print LATEST_RUBY_VERSION}')

echo "########### INSTALLING LATEST RUBY VERSION ${RUBY_VERSION} ###########"

rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION

echo "Installed ruby version:" 
ruby -v

gem install bundler
rbenv rehash
