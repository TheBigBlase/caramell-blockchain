// SPDX-License-Identifier: Beerware
pragma solidity >=0.4.22 <0.9.0;

contract storeData {
	bytes public data;
	int public what;
  constructor(int a) {
		data = msg.data;
		what = a;
  }

	function fuck() public view returns(int) {
		return what;
	}
}
