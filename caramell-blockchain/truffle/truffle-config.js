const PrivateKeyProvider = require("@truffle/hdwallet-provider");
const privateKey = "0097c6884fc3b1af44890df35467e5846347b5ceefc45fa4fa1941eac28ef362";
const privateKeyProvider = new PrivateKeyProvider(privateKey, "http://127.0.0.1:8545");

module.exports = {
  networks: {
   besuWallet: {
      provider: privateKeyProvider,
      network_id: "*",
    },   //
 },
	compilers: {
	 solc: {
		 version: "0.8.19"  // 8.20 doesnt deploy
	 }
  }
};
