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

contract clientContract {
	address _sender;
	Client c;
	constructor(address sender) {
		_sender = sender;
	}

	function clearClient() internal {
		//delete every key
		for(uint i = 0 ; i < c.keyList.length ; i++)  {
			bytes32 addrData = c.keyList[i];
			delete c.data[addrData];
		}
	}

	function addData(
			Data memory _data) public {
		bytes32 hashData = keccak256(bytes(_data.name));
		// check if client key exists, if not add it
		//check if data key exists
		if(c.data[hashData].timeCreated == 0) {
			c.keyList.push(hashData);
		}

		c.data[hashData] = _data;
	}

	function getAllData() external view returns(string memory){
		//get all data from a client, and format in json like fashion
		string memory res = "[\n";
		for(uint k = 0 ; k < c.keyList.length ; k++) {
			bytes32 idx = c.keyList[k];
			res = string.concat(res, indent(1), "{\n");
			res = string.concat(res, indent(2));
			res = string.concat(res, '"dataName":', c.data[idx].name, ',');
			res = string.concat(res, indent(2));
			res = string.concat(res, '"dataValue":', uint2str(c.data[idx].data), '\n');
			res = string.concat(res, indent(1), "},\n");
		}
		res = string.concat(res, "]");
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
