#! /usr/bin/env bash
# =======================================================================================================================
#   HEADER
# =======================================================================================================================
# 
#   SYNOPSIS
#       bashNote -lw -f <file>
#       
#   DESCRIPTION
#       A super minimal, as quick as possible, bash script to write or view notes from a file.
#
#   OPTIONS
#       -l,     list notes from file
#       -w,     write ntoes to file
#       -d,     delete a line from the file note
#
#   EXAMPLES
#       bashNote -l
#       bashNote -w
#       bashNote -d 4
#
#   Version=0.1
#   Author:github.com/TaureHorn
#   Date:29/11/2024
#
# =======================================================================================================================
#   END OF HEADER
# =======================================================================================================================

HELP() {
    echo -e '\033[1mBASHNOTE HELP\033[0m'
    echo -e 'List/write/delete notes\n'
    echo 'Syntax: bashNote [MODE...] [OPTION...]'
    echo 'EXAMPLES:'
    echo '  bashNote -l'
    echo '  bashNote -w'
    echo -e '  bashNote -d 4\n'
    echo 'MODE:'
    echo '  -l         list contents of note file'
    echo '  -w         write to note file'
    echo -e '  -d         delete line from note file. Append with line number'

}

# ARGUMENT HANDLING
if [[ $# == 0 ]]; then
    echo 'You must supply this command with arguments to tell it what mode to run in'
    echo "Try 'bashNote -h' for more information"
    exit
elif [[ $# -gt 2 ]]; then
    echo 'Too many arguments'
    echo "Try 'bashNote -h' for more information"
    exit
fi

# ARGUMENTS
while getopts 'hlwd' OPTION; do
    case $OPTION in
        h)  # print help
            HELP
            exit;;
        l)  # enable list mode
            READ_MODE=true;;
        w)  # enable writing mode
            READ_MODE=false;;
        d)  # enable deletion mode
            DELETE_MODE=true;;
        \? )
            exit;;
    esac
done

# FILE GETTER
if [[ -n $BASH_NOTE_FILE ]]; then
    if [[ ! -f $BASH_NOTE_FILE ]];then
        touch $BASH_NOTE_FILE
    fi
    FILE="$BASH_NOTE_FILE"
else
    if [ ! -f "$HOME/.bashNote" ]; then
        touch $HOME/.bashNote
    fi
    FILE="$HOME/.bashNote"
fi

if [[ $DELETE_MODE == true ]];then 
    if [[ ! -n $2 ]]; then
        > $FILE
    else 
        delete_result=$(sed "$2d" $FILE)
        echo "$delete_result" > $FILE
    fi

fi

# EXECUTE
if [[ $READ_MODE == true ]];then 
    i=1
    while read line; do
        echo $i: $line
        i=$(($i+1))
    done < $FILE
elif [[ $READ_MODE == false ]]; then
    read input
    echo "$input" >> "$FILE"
fi