#!/bin/bash


check_command_status () {
   if [ $? -eq 0 ]; then
      echo "$1 is successfull"
   else
      echo "$1 NOT is successfull !!!"
	   exit 1
	fi
}

echo update the ebt-ui

#login docker hub
docker login --username ulasdocker --password jmn65L2LfKauVXC

check_command_status "Login"

cd /home/epilog/ebt-ui/

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#pull the latest image from the hub
docker pull ulasdocker/epilog:latest

check_command_status "Pull from HUB"

# create a container to copy the deb and version file
id=$(sudo docker create ulasdocker/epilog:latest)
docker cp $id:/app .
docker rm -v $id

filename='/home/epilog/ebt-ui/app/version.txt'

n=1
arr=()
while read line; do
# reading each line
#echo "Line No. $n : $line"
arr[$n]=$line
n=$((n+1))
done < $filename

version=${arr[3]}
packageName=${arr[2]}

echo "packageName ${arr[2]}"
echo "version ${version}"

versionPath=/opt/versionEbtUi
packagePath=/home/epilog/ebt-ui/app/$packageName

if [ -e $versionPath ]
then
    echo "file exist"
    line=$(head -n 1 $versionPath)
    if [[ $line = $version ]]
    then
    	echo "versions are same"
    	exit 0
    else
    	echo "versions are not same"
	   dpkg -i $packagePath
      check_command_status "Deb package openning"
    	cat $version >> $versionPath
    fi
else
    echo "file is not exist"
    dpkg -i $packagePath #2>&1 | tee file.txt
    check_command_status "Deb package(was not exist) openning"
    touch $versionPath
    echo $version >> $versionPath
fi

echo "ebt-ui is updated ! Done ! version number $version"

sync
# reboot the system
reboot -f


