#!/bin/sh

# bind hosts to shortcuts
if [ $# != 1 ]; then
	echo "Ce vrei sa deschid, vito ?!"
	return
fi

source ~/scripts/eos_hosts.cfg

if [ ${hosts[$1]} ]; then
	ssh ${hosts[$1]}
else
	ssh $1
fi
