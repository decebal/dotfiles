#!/bin/sh

goto="/var/www/$1"

if [ -d $goto ]; then
    cd $goto
else
    goto="/var/www/$1.emag"
    if [ -d $goto ]; then
        cd $goto
    else
        goto=$1
        goto=${goto^^}
        which=$2
        goto="/var/www/$which.emag/vendor/$goto"
        if [ -d $goto ]; then
            cd $goto;
        else 
            echo "In $1 sa te duci tu cu prietenii tai !"
        fi
    fi
fi
