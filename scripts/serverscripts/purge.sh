#!/bin/bash
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
