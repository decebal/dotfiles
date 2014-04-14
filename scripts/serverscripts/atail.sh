#!/bin/bash
domains=( 'ro' 'bg' 'hu' )

for d in "${domains[@]}"; do
    file="/var/log/apache2/$1.emag.$d-access.log"
    if [ -f $file ]; then
        break
    fi
done
if [ -f $file ]; then
    tail -f $file | sed 's/\\n/\n/g' | sed 's/^\[/\n\n\[/g'
fi

