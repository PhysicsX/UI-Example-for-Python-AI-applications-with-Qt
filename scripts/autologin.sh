#!/bin/bash

#scritp is used to enable automatic login for ubuntu 18. It can be different for 20
#or other versions. 

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo bash) " 
   exit 1
fi


stringToChange="AutomaticLoginEnable"

if grep -q $stringToChange /etc/gdm3/custom.conf 
then
	lineNum="$(grep -n $stringToChange /etc/gdm3/custom.conf | cut -d: -f1)"

    	echo "it is found in ${lineNum}"
	lineNum="$(echo $lineNum | cut -d' ' -f2)"
    	echo $lineNum
	sed -i "${lineNum}s/.*/$stringToChange=True/" /etc/gdm3/custom.conf
	
	((lineNum++))
	sed -i "${lineNum}s/.*/AutomaticLogin=epilog/" /etc/gdm3/custom.conf
	
    	if [ $? -eq 0 ]
	then
	  echo "---- Automatic login enabled ----"
	  exit 0
	else
	  echo "---- Automatic login failed ----" >&2
	  exit 1
	fi

else
    echo "Command not found"
fi
