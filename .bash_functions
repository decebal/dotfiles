#! /bin/bash

function lsmod() {                                                             
    ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));if(k)printf("%0o ",k);print}'
}                                                                              

function fetch() {                                                             
    git fetch origin "$1":"$@"; git co "$1";                                   
}                                                                              

function mcd() {                                                               
    mkdir -p "$1" && cd "$1";                                                  
}        


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

