#! /usr/bin/env bash
i=0
if [ ! $1 ] 
then 
    limit=0
else
    limit=$(($1-1))
fi

MIN=1
MAX=100
#colors
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)

while [ $i -le $limit ];
    do
        RAND=$(($RANDOM%($MAX-$MIN+1)+$MIN))
        if [ $RAND == 100 ]
        then 
            printf "%s\n" "${GREEN}${RAND}${NORMAL}"
        elif [ $RAND == 1 ]
        then
            printf "%s\n" "${RED}${RAND}${NORMAL}"
        else
            echo -e $RAND
        fi
        ((i=i+1))
    done
