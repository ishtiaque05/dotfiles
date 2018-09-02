#!/bin/bash

# sudo apt-key list -  lists all keys installed in the system
# grep "expired: " - leave only lines with expired keys;
# sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' - extracts keys;
# xargs -n1 sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 
# updates keys from Ubuntu key server by found expired ones.

sudo apt-key list | \
 grep "expired: " | \
 sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' | \
 xargs -n1 sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
