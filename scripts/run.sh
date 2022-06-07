#!/bin/bash


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo bash) " 
   exit 1
fi

cd ..

/usr/local/QtEpilog/bin/qmake
make -j4

cd scripts

cp ebt_ui.service /etc/systemd/system
systemctl daemon-reload
systemctl enable ebt_ui.service
systemctl restart ebt_ui.service
systemctl daemon-reload

