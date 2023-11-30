#! /usr/bin/env bash
#
# music downloaded from Bandcamp has a numerical string in the filename which is kidna annoying
#       e.g. Witan - Elixir [123456789].mp3
# this script is designed to take in a file name and remove that numerical string and its brackets and rename the file
# it also should preseve directory names and can safely be used en masse
#
#       find . -name "*.mp3" -exec BC-removetag.sh {} \;
#
# will find all mp3 files within the current directory and rename those with the matching string '[12313213]'
# 
# do be careful with the string matching. E.g. Some songs in my library have a year tag in the name that would be removed here
#
INPUT="$(echo "$(basename "$1")" | sed 's/.\///g')"
SANS_STRING="$(echo "$INPUT" | sed 's/ \[[0-9]*\]//g')"
NEWNAME="$(dirname "$1")"/"$SANS_STRING"
echo "$NEWNAME"
mv "$1" "$NEWNAME"
