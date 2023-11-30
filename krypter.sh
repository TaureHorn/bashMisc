#! /usr/bin/env bash
# =======================================================================================================================
#   HEADER
# =======================================================================================================================
# 
#   SYNOPSIS
#       krypter -derf file secret-key
#       
#   DESCRIPTION
#       A script that takes to either encrypt or decrypt a file
#       In encryption mode it will convert a file or directory to a tar.gz archive, then encrypt that archive using the AES256 algorithm using a key you supply when prompted
#       In decryption mode the process is reversed. 
#       In both cases the .tar.gz file is temporary
#
#   OPTIONS
#       -d,     decrypt file
#       -e,     encypt file/ directory 
#       -r,     delete the original file on success
#       -f,     provide a secret key from a fil
#
#   EXAMPLES
#       krypter -e sensitive-file.txt
#       krypter -er ./nudes/
#       krypter -d video-tapes.gpg
#
#   Version=1.1
#   TODO's ------------------------------------------------------------
#       add checks to alert if tar or gpg are not installed
#
#   -------------------------------------------------------------------
# =======================================================================================================================
#   END OF HEADER
# =======================================================================================================================

# FUNCTIONS #############################################################################################
HELP() {
    echo -e '\033[1mKRYPTER HELP\033[0m'
    echo -e 'Encrypt or decrypt a file / directory with gpg \n'
    echo 'Syntax: krypter [OPTIONS...] [FILE]'
    echo -e 'enter secret key when prompted \n'
    echo 'DEPENDENCIES: [gpg, tar]'
    echo -e 'krypter uses tar to convert files /directories into/from archives, and uses gpg to encrypt/decrypt a file/directory using the AES-256 algorithm \n'
    echo 'EXAMPLES:'
    echo '  krypter -e file.txt'
    echo -e '  krypter -dr file.gpg \n'
    echo 'OPTIONS:'
    echo '  -e         encrypt file/directory'
    echo '  -d         decrypt file'
    echo -e '  -r         delete the original file on success \n'
}
getPassHash() {
    if [[ $XARG_HASH == 1 ]]; then 
        HASHED_KEY=$(cat $3)
        echo $HASHED_KEY
    else
        local KEY
        read -sp "Secret key: `echo $'\n> '`" KEY
        local HASH="$(echo $KEY | sha256sum)"
        HASHED_KEY=$(printf '%s\n' "${HASH%%" -"}") #remove trailing " -" from hash
    fi
}
decrypter() {
    getPassHash $@
    local NAME="${2%%.*}"
    $(gpg --output $NAME.tar.gz --batch --decrypt --passphrase $HASHED_KEY $2)
    if [[ -f "$NAME.tar.gz" ]]
    then
        echo -e '\033[1mDecryption successful!\033[0m'
        $(mkdir $NAME/)
        $(tar xzf $NAME.tar.gz -C $NAME/)
        $(rm $NAME.tar.gz)
        SUCCESS=1
    elif [[ ! -f "NAME.tar.gz" ]]
    then
        echo -e '\033[1mDECRYPTION FAILED!\033[0m'
        echo 'Perhaps you entered the wrong key. Please try again'
   fi
}
FILE=$2
encrypter() {
    local NAME="$(echo $(basename -a "$FILE") | tr " " - )"

    if [[ -d $FILE ]]; then
        $(tar czf $NAME.tar.gz --directory="$FILE" .)
    elif [[ -f $FILE ]]; then
        NAME=${NAME%%.*}
        $(tar czf $NAME.tar.gz "$2")

    fi
    if [[ -f $NAME.gpg ]]; then 
        echo 'An encrypted archive with that name already exists'
        exit
    fi

    getPassHash $@
    if [[ -f "$NAME.tar.gz" ]]; then
        $(gpg --cipher-algo AES256 --batch --symmetric --output $NAME.gpg --passphrase $HASHED_KEY $NAME.tar.gz)
        $(rm $NAME.tar.gz)
    fi
    if [[ -f "$NAME.gpg" ]]; then
        echo -e '\033[1mEncryption successful!\033[0m'
        SUCCESS=1
    fi
}


# ARGUMENT HANDLING ############################################################################
if [[ $# == 0 ]]; then
    echo 'krypter: You must specify which mode you want to run and which file or directory you want to target'
    echo "Try 'krypter -h' for more information"
    exit
elif [[ $# == 1 && $1 != "-h" ]]; then
    echo 'krypter: Two arguments are required, a mode and a file or directory'
    echo "Try 'krypter -h' for more information"
    exit
elif [[ $# -gt 3 ]]; then
    echo 'krypter: Too many arguments'
    echo "Try 'krypter -h' for more information"
    exit
fi

# ARGUMENT PARSER
while getopts 'hfred' OPTION; do
    case $OPTION in
        h) # print help
            HELP
            exit;;
        f) # feed in file for password hash
            XARG_HASH=1
            ;;
        r) # delete orignal file on process completion
            DELETE_MODE=1;;
        e) # encrypt file
            MODE=0;;
        d) # decrypt file
            MODE=1;;
        \? )
            echo 'Error. -'$OPTARG' Invalid option'
            exit;;
    esac
done

# HASH INPUT CHECKER
if [[ $XARG_HASH == 1 && $# -lt 3 ]]; then
    echo 'krypter: You must pass in a file to use as a hash'
    exit
fi

# FUNCTION TRIGGERS
if [[ $MODE == 0 ]]; then
    encrypter $@
elif [[ $MODE == 1 ]]; then
    decrypter "$@"
fi

# DELETE CHECKER AND TRIGGER
if [[ $DELETE_MODE == 1 && $SUCCESS == 1 ]]; then
    $(rm -rf $2)
fi
