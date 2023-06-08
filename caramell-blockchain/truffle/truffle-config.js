const PrivateKeyProvider = require("@truffle/hdwallet-provider");
const privateKey = "871b3c641cfb5c10a453d7fff38737081388bce7c3a3ca36a1daebd241431bf9";
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
