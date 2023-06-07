#!/bin/node

const accounts = require('web3-eth-accounts');

let res = accounts.create();
console.log("key = " + res.privateKey + "\naddress = " + res.address);
