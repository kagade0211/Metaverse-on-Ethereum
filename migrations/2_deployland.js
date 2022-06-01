const Land = artifacts.require("Land");
// requires  artifact of land smart contract i.e. json file that represent smart contract
module.exports = function async (deployer) {
 // use async as we are waiting until contract gets deployed
  deployer.deploy(Land);
  // besides land smart contract we have to pass NAME,SYMBOL AND COST
  const NAME = 'DApp U Buildings'
  const SYMBOL = 'DUB'
  // smart contracts only take in wei hence need to convert eth to wei using web3 library function
  const COST = web3.utils.toWei('1', 'ether')
  //wait until contract gets deployed
  await deployer.deploy(Land, NAME, SYMBOL, COST)
};
