#!/bin/bash

if [ $EUID -ne 0 ]
  then printf "\e[1;91m Please run as root \e[0m\n"
  exit
fi

if command -v rsync > /dev/null 2>&1; then
    echo "Program exists" > /dev/null 2>&1
else
    sudo apt install rsync -y
fi

current_date=$(date +%Y-%m-%d)

what_to_backup=""

server_username=""
server_passwd=""
server_ip=""

$(rsync) -a -v --remove-source-files $what_to_backup $server_username@$server_ip:/home/$server_username/backup/$current_date

sleep 2
echo "yes"
sleep 2
echo $server_passwd

if [ $? -eq 0 ]; then
    printf "\e[1;92m Backup Done \e[0m\n"
    exit
else
  printf "\e[1;91m Problem Occurred \e[0m\n"
fi
