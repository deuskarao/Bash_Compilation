#!/bin/bash

# -----------------------------------

function timer(){
    echo -e "\n"
    for i in {0..10000000}; do echo -ne "TIME PASSED (s):  $i"'\r'; sleep 1; done; echo
}

function main(){
    change_to="/Users/god"
    backup_folder="CLOUD/"
    backup_save="/Users/god/backups/daily"
    tree_f="$change_to/cloud_tree.txt"

    file_c="$change_to/file_detail" # c exe to get details of a folder/file

    dest_folder="~/backups/daily/"
    ssh_alias="username@ip"

    # ------------------------------------

    # checking necessity
    if command -v rsync > /dev/null 2>&1; then
        printf " \e[1;42mRsync Exists! \e[0m\n"
    else
        sudo apt install rsync -y
    fi
    sleep 3

    # creating if CLOUD folder doesnt exist
    if [ ! -d "$change_to/CLOUD" ]; then
        printf " \e[1;41mCLOUD FOLDER DOES NOT EXIST! \e[0m\n"
        sleep 3
        mkdir $change_to/CLOUD
        printf " \e[1;42mCLOUD FOLDER CREATED \e[0m\n"
        sleep 3
    fi

    printf " \e[1;45mSCRIPT RUNNING! \e[0m\n" "%q\n"

    # Copy dirs into cloud dir
    cp -r $change_to/Codes $change_to/CLOUD/Codes > $change_to/$(date +%F)_backup.log 2>&1
    cp -r $change_to/Others $change_to/CLOUD/Others >> $change_to/$(date +%F)_backup.log 2>&1

    # tar backup_folder into backup_save location
    tar -zcvf $backup_save/$(date +%F).tar.gz -C $change_to $backup_folder >> $(date +%F)_backup.log 2>&1
    tar_err="$?"

    # rsync that tar file into server/client
    rsync -a $backup_save/ $ssh_alias:$dest_folder
    sync_err="$?"

    # --- find and delete backup tars older than a week ---
    find $change_to/backups/daily/* -mtime +7 -delete

    # Exit
    if [ "$tar_err" == "0" ] && [ "$sync_err" == "0" ]; then
        printf " \e[1;42mBackup Done \e[0m\n"

        tree $change_to/CLOUD > $tree_f
        echo -e "\n" >> $tree_f

        size=$(du -sh $change_to/CLOUD | awk '{print $1}')
        echo -e "Size:     $(du -sh $change_to/CLOUD | awk '{print $1}')" >> $tree_f

        $file_c $change_to/CLOUD >> $tree_f

        printf " \e[1;46mCHECK OUT TREE VIEW OF BACKUP --> $tree_f \e[0m\n"
        exit

    else
    printf " \e[1;41m Problem Occurred \e[0m\n"
    exit
    fi
}

# multi thread
timer & main
