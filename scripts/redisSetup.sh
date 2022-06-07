#!/bin/bash


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo bash) " 
   exit 1
fi

apt install redis-server -y

# Assign the filename
filename="/etc/redis/redis.conf"

# Take the search string
search="supervised on"

# Take the replace string
replace="supervised systemd"

if [[ $search != "" && $replace != "" ]]; then
sed -i "s/$search/$replace/" $filename
fi

systemctl restart redis.service
