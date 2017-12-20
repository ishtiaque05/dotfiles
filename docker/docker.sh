#!/usr/bin/env bash

release_name=`lsb_release -csu 2> /dev/null || lsb_release -cs 2> /dev/null`
[[ "$release_name" = "" ]] && release_name="xenial"

# installing
if which docker > /dev/null ; then
  echo "########## docker already installed. Skipping ..."
else
  echo "########## adding docker ppa ..."
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${release_name} stable"
  sudo apt-get update -y
  echo "########## Installing docker ..."
  echo "########## Creating docker data directory in home partition ..."
# making different partition to contain docker data
  sudo mkdir -p /home/docker_data_dir
  pushd /var/lib/
  sudo ln -s /home/docker_data_dir docker
  popd
  sudo apt-get install docker-ce -y --force-yes
fi