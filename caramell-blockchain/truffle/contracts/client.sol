// SPDX-License-Identifier: Beerware
pragma solidity >=0.4.22 <0.9.0;

struct Data {
	string name; //has to be unique
	uint256 data;
	uint timeCreated;
	uint timeToStore;
}

struct Client {
	mapping (bytes32 => Data) data;
	string name;
	bytes32[] keyList;
}

contract client {
	//Client[] public clients;//for now just a vector, 
	//later we can try to see if a bin tree is more efficient

	//i changed my mind lets try mappings
	mapping (bytes32 => Client) clients;
	bytes32[] listClientKey;
	address _sender;
	//oh god
	//uh so it is a map of maps, so key1 gives client, key2 keys
	//each client has a map of keys
	//each keys (client or data) is the hash of addr

	constructor(address sender) {
		_sender = sender;
	}

	function clearClient(bytes32 hashAddr) internal {
		//delete every key
		for(uint i = 0 ; i < clients[hashAddr].keyList.length ; i++)  {
			bytes32 addrData = clients[hashAddr].keyList[i];
			delete clients[hashAddr].data[addrData];
		}
	}

	function deleteClient(string calldata _addr) internal {
		bytes32 hashAddr = keccak256(bytes(_addr));

		clearClient(hashAddr);
		delete clients[hashAddr];
	}

	function clientAddData(
			string calldata _addr,
			Data memory _data) public {
		bytes32 hashAddr = keccak256(bytes(_addr));
		bytes32 hashData = keccak256(bytes(_data.name));

		// check if client key exists, if not add it
		if(clients[hashAddr].keyList.length == 0) {
			listClientKey.push(hashAddr);
			clients[hashAddr].keyList = new bytes32[](1);
		}

		//check if data key exists
		if(clients[hashAddr].data[hashData].timeCreated == 0) {
			clients[hashAddr].keyList.push(hashData);
		}

		clients[hashAddr].data[hashData] = _data;
	}

	function getAllData(Client storage c, uint8 i) internal view returns(string memory){
		//get all data from a client, and format in json like fashion
		string memory res = "";
		for(uint k = 0 ; k < c.keyList.length ; k++) {
			bytes32 idx = c.keyList[k];
			res = string.concat(res, indent(i - 1), "{\n");
			res = string.concat(res, indent(i));
			res = string.concat(res, '"dataName":', c.data[idx].name, ',');
			res = string.concat(res, indent(i));
			res = string.concat(res, '"dataValue":', uint2str(c.data[idx].data), '\n');
			res = string.concat(res, indent(i - 1), "},\n");
		}
		return res;
	}

	function getAllClient() external view returns(string memory){
		//get all client and their data, format it in a json like fashion
		string memory res = "{\n";
		for(uint i = 0 ; i < listClientKey.length ; i++)  {
			bytes32 idx = listClientKey[i];
			res = string.concat(res, indent(1));
			res = string.concat(res, '"clientName":"', clients[idx].name, '",\n');
			res = string.concat(res, indent(1));
			res = string.concat(res, '"clientData":', getAllData(clients[idx], 2), '\n');
			res = string.concat(res, indent(1));
			res = string.concat(res, '},\n');
		}
		res = string.concat(res, '}');
		return res;
	}

	function indent(uint8 i) internal pure returns(string memory){
		string memory res = "";
		for( ; bytes(res).length < i ; ) {
			res = string.concat(res, "\t");
		}
		return res;
	}

	//stole that from https://stackoverflow.com/questions/47129173/how-to-convert-uint-to-string-in-solidity
	function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
		if (_i == 0) {
			return "0";
		}
		uint j = _i;
		uint len;
		while (j != 0) {
			len++;
			j /= 10;
		}
		bytes memory bstr = new bytes(len);
		uint k = len;
		while (_i != 0) {
			k = k-1;
			uint8 temp = (48 + uint8(_i - _i / 10 * 10));
			bytes1 b1 = bytes1(temp);
			bstr[k] = b1;
			_i /= 10;
		}
		return string(bstr);
	}
}
