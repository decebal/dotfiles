#!/bin/sh
a=$#
if [ $a -lt 1 ]; then 
    echo "Ce cache vrei sa stergi ?" 
else 
    f="/var/www/$1.emag"
    if [ -d $f ]; then
        c="$f/app/cache/*"
        rm -rf $c
        cc="$f/web/cache"
        if [ -d $cc ]; then
            ccj="$cc/js/*.js"
            rm -rf $ccj
            ccj="$cc/css/*.css"
            rm -rf $ccj
        fi
    else
        echo "$f nu exista"
    fi
fi
