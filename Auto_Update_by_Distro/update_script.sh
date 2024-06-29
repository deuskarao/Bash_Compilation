#!/bin/bash

# --------- # FOR MY MAC

brew update 
 
if [ $? -eq 0 ] 
then
    brew upgrade 
fi


# --------- FOR LINUX

if [ -d /etc/apt ]; then
    sudo nala update && sudo nala uograde -y

fi

# ----------

