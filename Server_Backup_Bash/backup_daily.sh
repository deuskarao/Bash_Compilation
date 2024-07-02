#!/bin/bash

# -----------------------------------

change_to="/Users/god/"
backup_folder="CLOUD/"
backup_save="/Users/god/backups/daily"

dest_folder="~/backups/daily/"
ssh_alias="deus@47.34.47.154"

# ------------------------------------

# checking necessity
if command -v rsync > /dev/null 2>&1; then
    printf "\e[1;92m Rsync Exists! \e[0m\n"
else
    sudo apt install rsync -y
fi
sleep 5


# Copy dirs into cloud dir
cp -r $change_to/Codes $change_to/CLOUD/Codes
cp -r $change_to/Others $change_to/CLOUD/Others

# tar backup_folder into backup_save location
tar -zcvf $backup_save/$(date +%F).tar.gz -C $change_to $backup_folder

# rsync that tar file into server/client
rsync -a $backup_save/ $ssh_alias:$dest_folder

# --- find and delete backup tars older than a week ---
find ~/backups/daily/* -mtime +7 -delete

# Exit
if [ $? -eq 0 ]; then
    printf "\e[1;92m Backup Done \e[0m\n"
    exit
else
  printf "\e[1;91m Problem Occurred \e[0m\n"
fi
