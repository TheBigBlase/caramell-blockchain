let storeData = artifacts.require("storeData");

module.exports = function(deployer) {
	deployer.deploy(storeData, 5);

  // Use deployer to state migration tasks.
};
