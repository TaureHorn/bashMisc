#! /usr/bin/env bash
# =======================================================================================================================
#   HEADER
# =======================================================================================================================
# 
#   SYNOPSIS
#       bashNote -lw -f <file>
#       
#   DESCRIPTION
#       A super minimal, as quick as possible, bash script to write/view/delete notes from a file.
#
#   OPTIONS
#       -l,     list contents of notes file
#       -w,     write ntoes to file
#       -d,     delete a line from the file note
#       -t,     supply a specific notes file
#
#   EXAMPLES
#       bashNote -l
#       bashNote -w "Buy eggs, milk, bread & sanity"
#       bashNote -d 4 -f ~/newNotes
#
#   FILES
#       If not supplied a file using the -f option, bashNote will default to specific files. 
#       If the environment variable BASH_NOTE_FILE is set, bashNote will use that to source a file.
#       Otherwise, bashNote will use $HOME/.bashNote to source a file.
#       In either case, a file will be automatically created in the location if one does not exist.
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
    echo -e '\033[1mSyntax:\033[0m bashNote [MODE...] [OPTION...]\n'
    echo 'EXAMPLES:'
    echo '  bashNote -l'
    echo '  bashNote -w "Buy eggs, milk, break & sanity"'
    echo -e '  bashNote -d 4 -f ~/newNotes\n'
    echo 'MODE:'
    echo '  -l         list contents of note file'
    echo '  -w         write to note file. append with message'
    echo '  -d         delete line from note file. append with line number'
    echo -e '  -f         operate on a specific file. append with file path\n'
    echo 'FILES:'
    echo -e 'If not supplied a file using the -f option, bashNote will default to specific files. If the environment variable BASH_NOTE_FILE is set, bashNote will use that to source a file. Otherwise, bashNote will use $HOME/.bashNote to source a file. In either case, a file will be automatically created in the location if one does not exist\n'
}

# ARGUMENT CHECKER
if [[ $# == 0 ]]; then
    echo 'You must supply this command with arguments to tell it what mode to run in'
    echo "Try 'bashNote -h' for more information"
    exit
fi

# ARGUMENT PARSER
while getopts 'hlw:d:f:' OPTION; do
    case $OPTION in
        h)  # print help
            HELP
            exit;;
        l)  # enable list mode
            READ_MODE=true;;
        w)  # enable writing mode
            WRITE_MODE=true
            INPUT="$OPTARG";;
        d)  # enable deletion mode
            DELETE_MODE=true
            DELETE_LINE="$OPTARG";;
        f) # set custom notes file
            FILE="$OPTARG";;
        \? )
            exit;;
    esac
done

# FILE GETTER
if [[ -z $FILE ]]; then 
    if [[ -n $BASH_NOTE_FILE ]]; then
        if [[ ! -w $BASH_NOTE_FILE ]];then
            touch "$BASH_NOTE_FILE"
        fi
        FILE="$BASH_NOTE_FILE"
    else
        if [ ! -w "$HOME/.bashNote" ]; then
            touch "$HOME/.bashNote"
        fi
        FILE="$HOME/.bashNote"
    fi
fi

# CHECK IF FILE EXITS AND EXIT IF NOT
FILE_CHECKER() {
    if [[ ! -w $1 ]]; then
        echo "File '$1' does not exist or is not writable"
        exit
    fi
}

# DELETER
if [[ $DELETE_MODE == true ]];then 

    FILE_CHECKER "$FILE"
    
    if [[ $DELETE_LINE == "*" ]]; then
        # delete file contents
        echo "Deleting all notes in $FILE"
        true > "$FILE"
    else 

        # delete specific line number in file
        DELETE_RESULT=$(sed "${DELETE_LINE}d" "$FILE")
        echo "$DELETE_RESULT" > "$FILE"
    fi
fi

# WRITER - APPEND INPUT TO FILE
if [[ -n $WRITE_MODE ]]; then 
    echo "$INPUT" >> "$FILE"
fi

# READER - ITERATE THROUGH FILE LINE BY LINE
if [[ -n $READ_MODE ]];then 

    FILE_CHECKER "$FILE"

    i=1
    while read -r line; do
        echo $i: "$line"
        i=$((i + 1))
    done < "$FILE"
fi

