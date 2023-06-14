let clientFactory = artifacts.require("clientFactory");
//let client = artifacts.require("client");

module.exports = function(deployer) {
	deployer.deploy(clientFactory);

  // Use deployer to state migration tasks.
};
