#!/bin/bash
cd "$(dirname "$0")" 

npm install web3-eth-accounts
key=$(node ./createKeys.js)
if [[ -n $(grep "[config]" "./Cargo.toml") && -n address && -n privateKey ]]; then
	echo "adding keys to toml";
	echo "$key"
	echo "\n[config]" >> ./Cargo.toml
	echo "$key" >> ./Cargo.toml
fi 
