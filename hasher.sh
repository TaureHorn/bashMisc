#! /usr/bin/env bash

# Take in a password and hash it
read -sp "Secret key: " KEY
# check for empty key string
if [ "$KEY" == "" ]; then
    echo -e "\nYou must enter a secret key to be hashed"
    exit
fi
HASH="$(echo $KEY | sha256sum)"
HASHED_KEY=$(printf '%s\n' "${HASH%%" -"}") #remove trailing " -" from hash

# Take in file name
echo -e '\b'
read -p 'File name: ' PREFIX

# check for empty name string
if [ "$PREFIX" == "" ]; then
    PREFIX="hash"
fi

# write file if not exists
if [ -f $PREFIX.sha256sum ];then 
    echo -e "\nA file with that name already exists"
    exit
else
    echo $HASHED_KEY >> $PREFIX.sha256sum
fi
