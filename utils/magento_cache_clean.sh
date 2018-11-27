#! /usr/bin/env bash

#/usr/local/bin : put the script in bin folder to assist in development

echo 'Running:-----------------------cache:clean' && \
sudo php bin/magento cache:clean && \
echo 'Running:-----------------------cache:flush' && \
sudo php bin/magento cache:flush && \
echo 'Running:-----------------------chmod -R 777 .'&& \
sudo chmod -R 777 .

