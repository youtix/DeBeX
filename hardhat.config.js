require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

require('dotenv').config({ path: './.env' });

module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "hardhat",
  networks: {
    goerli: {
      url: process.env.GOERLI_RPC_URL,
      accounts: [process.env.GOERLI_PRIVATE_KEY],
    },
  }
};