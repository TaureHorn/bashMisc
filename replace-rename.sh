#! /usr/bin/env bash
#
# provide a sed string as $1
# e.g. 's/foo/bar/'
#

for i in *
do 
    mv "$i" "`echo $i | sed $1`"
done
