#!/bin/bash

# command example: copy_from_multiple_server.sh server_directory target_file destination_folder

USERNAME=deployer
HOSTS="812.123.4.123 123.123.123.123 456.456.456.456"

cd $3

if which sshpass > /dev/null; then
  echo "########## sshpass already installed. Skipping ..."
else
  echo "########## Installing sshpass ..."
  sudo apt-get install -y --force-yes sshpass
fi

for HOSTNAME in ${HOSTS} ; do
    sshpass -p 'password' scp ${USERNAME}@${HOSTNAME}:$1/$2 .
    mv $2 ${HOSTNAME}_$2
    echo "SUCCESS::COPIED $2 FROM ${HOSTNAME} TO $3 "
done
