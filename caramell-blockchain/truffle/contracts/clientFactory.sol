// SPDX-License-Identifier: Beerware
pragma solidity >=0.4.22 <0.9.0;

import "./client.sol";

contract clientFactory {
	client[] clientList;

	function newClient() external returns(address payable) {
		client c = new client(msg.sender);
		address payable clientContract = payable(address(c));

		clientList.push(c);
		return clientContract;
	}
}
