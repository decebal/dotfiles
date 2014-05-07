#!/bin/bash
if [ ! -f $DOTFILES/local/hosts.cfg ]; then
    echo " Please create $DOTFILES/local/hosts.cfg in order for this to work "
    echo " You can follow the example from $DOTFILES/common/scripts/hosts-example.cfg "
    exit
fi

source $DOTFILES/local/hosts.cfg
arg=( "$@" )

verbose=0
for a in "${arg[@]}"; do
    if [ "$a" == "-v" ]; then
        verbose=1
    fi
done

for i in ${!hosts[@]}; do
    key=$i
    i=${hosts[$i]}
    copy=1
    if [ $# -gt 0 ]; then
        copy=0
        for a in "${arg[@]}"; do
            if [ $a == $i -o $a == $key ]; then
                copy=1
            fi
        done
    fi
    if [ $copy -eq 1 ]; then
        if [ $verbose -eq 0 ]; then
            echo -ne "Copy scripts for $key ($i) started..."
            ssh-copy-id $i 1>/dev/null 2>&1
            ##### Here I may want to clone or check the repo-s status
            #### the repo should be set in a config
            # echo 'if [[ ! -d ~/sh ]]; then mkdir ~/sh; fi' | ssh $i 1>/dev/null 2>&1
            # for j in ~/scripts/serverscripts/*; do
            #     scp $j $i:~/sh/ 1>/dev/null 2>&1
            # done
            # echo "chmod +x ~/sh/*" | ssh $i 1>/dev/null 2>&1
            # scp ~/scripts/bash_aliases $i:~/.bash_aliases 1>/dev/null 2>&1
            # scp ~/scripts/id/* $i:~/.ssh/ 1>/dev/null 2>&1   //why would you want to do this ??
            # echo "chmod 600 ~/.ssh/*" | ssh $i 1>/dev/null 2>&1
            #echo "git config --global user.name 'User Name'" | ssh $i 1>/dev/null 2>&1
            #echo "git config --global user.email 'user.email@emag.ro'" | ssh $i 1>/dev/null 2>&1
            echo "done"
        else
            ssh-copy-id $i
            # echo 'if [[ ! -d ~/sh ]]; then mkdir ~/sh; fi' | ssh $i
            # for j in ~/scripts/serverscripts/*; do
            #     scp $j $i:~/sh/
            # done
            # echo "chmod +x ~/sh/*" | ssh $i
            # scp ~/scripts/bash_aliases $i:~/.bash_aliases
            # scp ~/scripts/id/* $i:~/.ssh/ //why would you want to do this ??
            # echo "chmod 600 ~/.ssh/*" | ssh $i
            # echo "git config --global user.name 'User Name'" | ssh $i
            # echo "git config --global user.email 'user.email@emag.ro'" | ssh $i

        fi

    fi
done