#! /bin/bash

#alias error_log="tail -f /var/log/apache2/*"                           
function lsmod() {                                                             
    ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));if(k)printf("%0o ",k);print}'
}                                                                              

function fetch() {                                                             
    git fetch origin "$1":"$@"; git co "$1";                                   
}                                                                              

function mcd() {                                                               
    mkdir -p "$1" && cd "$1";                                                  
}        

function error_log() {
    if [ -z "$1" ]  || [ ! -f /var/log/apache2/"$1"-error.log ]; then
        tail -f /var/log/apache2/www.emag.ro-error.log
    else
        tail -f /var/log/apache2/"$1".emag.ro-error.log
    fi
}

function purge_cache() {
    if [ "$#" -eq "1" ]; then
        if [[ "$1" == *s1.emagst.ro* ]]; then
            domains=( 's1.emagst.ro' 'lb1.emag.ro' 'lb2.emag.ro' )
                for domain in ${domains[@]}; do
                    echo $domain
                        echo "curl -X GET -I '$1?PURGE'" | sed -e "s/https?:\/\//http:\/\//" -e "s/s1.emagst.ro/$domain/" | bash;
    echo "curl -X GET -I '$1?PURGE'" | sed -e "s/https?:\/\//https:\/\//" -e "s/s1.emagst.ro/$domain/" | bash;
    done
        fi
        if [[ "$1" == *s1.emagst.bg* ]]; then
            domains=( 's1.emagst.bg' 'www1-bg.emag.bg' 'www2-bg.emag.bg' )
                for domain in ${domains[@]}; do
                    echo $domain
                        echo "curl -X GET -I '$1?PURGE'" | sed -e "s/https?:\/\//http:\/\//" -e "s/s1.emagst.bg/$domain/" | bash
                        echo "curl -X GET -I '$1?PURGE'" | sed -e "s/https?:\/\//https:\/\//" -e "s/s1.emagst.bg/$domain/" | bash
                        done
                        fi
                        fi
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

