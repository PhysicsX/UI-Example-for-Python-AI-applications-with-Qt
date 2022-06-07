#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo bash) " 
   exit 1
fi

systemctl stop ebt_ui.service

apt-get install git make g++ libusb-1.0-0-dev libgtk2.0-dev
make
sleep 3
chmod +x AR1100
./AR1100 -c 9 -m
   echo "Calibrating the screen is done ! " 
