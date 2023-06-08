#!/bin/bash

cd "$(dirname "$0")"

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
} 

if [[ -d ../files/Node-1 || -d ../files/Node-2 \
	|| -d ../files/Node-3 || -d ../files/Node-3 ]] ; then
	(yes_or_no "file exists. Overwrite ?" && 
		for k in $(seq 4); do 
			rm -rf ../files/Node-$k/data ;
		done;
	rm -rf ../files/networkFiles ../files/genesis.json) || exit -1
fi;

for k in $(seq 4) ; do
	mkdir -p ../files/Node-$k/data;
done;

besu operator generate-blockchain-config --config-file=./qbftInit.json --to=../files/networkFiles --private-key-file-name=key;

i=1
for k in ../files/networkFiles/keys/* ; do 
	cp $k/key* ../files/Node-$i/data/;
	i=$(($i+1));
done

cp ../files/networkFiles/genesis.json ../files/
