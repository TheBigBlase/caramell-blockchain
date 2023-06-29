// SPDX-License-Identifier: Beerware
pragma solidity >=0.4.22 <0.9.0;

import "./clientContract.sol";

contract clientFactory {
	event contractCreated(address owner, address contract_address);

	mapping (address => clientContract) public clientList;

	// external ; one used by client
	function newClient() external {
		address _sender = msg.sender;
		newClient(_sender);
	}

	// internal ; client only
	function newClient(address _sender) internal returns (clientContract){
		clientContract client = clientList[_sender];

		if(address(client) == address(0)) {
			client = new clientContract(_sender, address(this));
			//clientContractAddress = payable(address(c));
			clientList[_sender] = client;
		}

		emit contractCreated(_sender, address(client));
		return client;
	}

	function getClient() external view returns(address payable) {
		return payable(address(clientList[msg.sender]));
	}

	// recreate a client contract, and deprecate the old one
	function renewClient() external {
		address _sender = msg.sender;

		clientContract newC = newClient(_sender);
		clientContract oldC = clientList[_sender];
		oldC.setNewContract(address(newC));
	}
}
