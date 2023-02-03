require("hardhat-deploy")
require("hardhat-deploy-ethers")

const { networkConfig } = require("../helper-hardhat-config")

const private_key = network.config.accounts[0]
const wallet = new ethers.Wallet(private_key, ethers.provider)

module.exports = async ({ deployments }) => {
    console.log("Wallet Ethereum Address:", wallet.address)
    const chainId = network.config.chainId
    const tokensToBeMinted = networkConfig[chainId]["tokensToBeMinted"]

    //deploy the Fillion Artist contract
    const FillionArtist = await ethers.getContractFactory("FillionArtist", wallet)
    console.log("Deploying the FillionArtist contract...")
    const fillionArtist = await FillionArtist.deploy()
    await fillionArtist.deployed()
    console.log("FillionArtist contract deployed to:", fillionArtist.address)

    // //deploy the Factory contract
    // const Factory = await ethers.getContractFactory("Factory", wallet)
    // console.log("Deploying the Collection contract...")
    // const factory = await Factory.deploy()
    // await factory.deployed()
    // console.log("Factory deployed to:", factory.address)

    // //deploy the Collection contract
    // const Collection = await ethers.getContractFactory("Collection", wallet)
    // console.log("Deploying the Collection contract...")
    // const collection = await Collection.deploy()
    // await collection.deployed()
    // console.log("Collection deployed to:", collection.address)
}
