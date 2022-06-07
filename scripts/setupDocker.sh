#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo bash) " 
   exit 1
fi

apt-get remove docker docker-engine docker.io containerd runc -y

apt-get update -y

apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
apt-get update -y

apt-get install docker-ce docker-ce-cli containerd.io -y

x=1
while [ $x -le 5 ]
do
  echo "Wait for docker setup !"
  x=$(( $x + 1 ))
  sleep 1
done

systemctl start docker

docker run hello-world

if [ $? -eq 0 ]; then
   echo "docker is set up"
else
   echo "docker is NOT set up"
fi

# remove hello world example after testing
docker system prune -af > /dev/null

# add cron job for automatic update
# default place to store the crone
touch /var/spool/cron/crontabs/root
crontab -l > mycron
# echo new cron into cron file to run every 12:10:00 - At minute 10 past every 12th hour
# https://crontab.guru/#10_*/12_*_*_*
echo "39 */01 * * * /bin/bash /home/epilog/ebt-ui/updateApp.sh" >> mycron
# install new cron file
crontab mycron
rm mycron


