let store = artifacts.require("storeData");

module.exports = function(deployer) {
	deployer.deploy(store);

  // Use deployer to state migration tasks.
};
