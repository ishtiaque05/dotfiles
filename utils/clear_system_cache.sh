#!/bin/bash

free -m && echo 3 | sudo tee /proc/sys/vm/drop_caches && free -m

