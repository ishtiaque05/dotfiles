#!/usr/bin/env bash 

# /usr/local/bin: put the script here to make it accessible everywhere

echo 'Running:--------------------------setup:upgrade' && \
sudo php bin/magento setup:upgrade && \
echo 'Running:--------------------------setup:di:compile' && \
sudo php bin/magento setup:di:compile && \
echo 'Running:--------------------------setup:static-content:deploy' && \
sudo php bin/magento setup:static-content:deploy && \
echo 'Running:--------------------------cache:clean' && \
sudo php bin/magento cache:clean && \
echo 'Running:--------------------------cache:flush' && \
sudo php bin/magento cache:flush && \
echo 'Running:--------------------------chmod -R 777 .' &&\
sudo chmod -R 777 .


