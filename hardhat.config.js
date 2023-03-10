require("@nomicfoundation/hardhat-toolbox")
require("hardhat-deploy")
require("hardhat-deploy-ethers")
require("./tasks")
require("dotenv").config()
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-ethers");

const PRIVATE_KEY = process.env.PRIVATE_KEY
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
      solidity: {
        version: "0.8.17", 
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
    defaultNetwork: "hyperspace",
    networks: {
        hyperspace: {
            chainId: 3141,
            //url: "https://api.hyperspace.node.glif.io/rpc/v1",
            url: "https://filecoin-hyperspace.chainstacklabs.com/rpc/v1",
            accounts: [PRIVATE_KEY],
            //gas: 200000,
        },
    },
    paths: {
        sources: "./contracts",
        tests: "./test",
        cache: "./cache",
        artifacts: "./artifacts",
    },
}
