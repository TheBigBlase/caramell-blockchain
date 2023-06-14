// SPDX-License-Identifier: Beerware
pragma solidity >=0.4.22 <0.9.0;

import "./clientContract.sol";

contract clientFactory {
	event contractCreated(address owner, address contract_address);

	mapping (address => address payable) public clientList;

	function newClient() external {
		address payable clientContractAddress = clientList[msg.sender];

		if(clientContractAddress == address(0)) {
			clientContract c = new clientContract(msg.sender);
			clientContractAddress = payable(address(c));
			clientList[msg.sender] = clientContractAddress;
		}

		emit contractCreated(msg.sender, clientContractAddress);
	}

	function getClient() external view returns(address payable) {
		return clientList[msg.sender];
	}
}
