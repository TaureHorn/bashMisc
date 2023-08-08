#! /usr/bin/env bash
#
# script for encryption / decryption of folders and files
#       encrypt | take in file or directory >>> tar.gz >>> encrypt >>> delete file/directory & tar.gz
#       decrypt | take in encrypted file >>> decrypt to tar.gz >>> unarchive to file/directory >>> delete tar.gz and encrypted file
#
# NOTES 
#       tar czf <name.tar.gz> --directory=<name>/ .
#       
#       mkdir <dirName>
#       tar xzf <name.tar.gz> -C <dirName>
#       
#       gpg --cipher-algo AES256 --symmetric <name.tar.gz>
#
#       gpg --output <name.tar.gz> --decrypt <name.tar.gz.gpg>
#
#
${1?: You must select whether to encrypt or decrypt}
${2?: You must supply a file or folder}
#
#   TODO add better argument checking and error handling
#   TODO add help output
#   TODO add ability to parse file / directory input from outside local directory >>> basename?
#    
getPassHash() {
    local PASS
    read -sp "Password: " PASS
    local HASH="$(echo $PASS | sha256sum)"
    HASHED_PASS=$(printf '%s\n' "${HASH%%" -"}") #remove trailing " -" from hash
}
decrypter() {
    getPassHash
    local NAME="${2%%.*}"
    $(gpg --output $NAME.tar.gz --batch --decrypt --passphrase $HASHED_PASS $2)
    $(mkdir $NAME/)
    $(tar xzf $NAME.tar.gz -C $NAME/)
    $(rm $NAME.tar.gz)
}
encrypter() {
    if [[ -d "$2" ]]
    then
        local NAME="$(basename $2)"
        $(tar czf $NAME.tar.gz --directory=$NAME/ .)

    elif [[ -f "$2" ]]
    then
        local NAME="${2%%.*}"
        $(tar czf $NAME.tar.gz $2)
    fi

    getPassHash
    echo ""
    $(gpg --cipher-algo AES256 --batch --symmetric --passphrase $HASHED_PASS $NAME.tar.gz)
    $(rm $NAME.tar.gz)
}

if [[ $1 == "--decrypt" || $1 == "-d" || $1 == "decrypt" ]]
then
    decrypter $1 $2

elif [[ $1 == "--encrypt" || $1 == "-e" || $1 == "encrypt" ]]
then
    encrypter $1 $2
fi

deleter() {
    if [[ $1 == "--rm-original" || $1 == "-r" ]]
    then
        $(rm $2)
    fi
}

if [[ -n "$3" ]]
then
    deleter $3 $2
fi
