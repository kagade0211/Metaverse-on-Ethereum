const Land = artifacts.require("Land");
// requires  artifact of land smart contract i.e. json file that represent smart contract
module.exports = function (deployer) {
  deployer.deploy(Land);
  const NAME = 'DApp U Buildings'
  const SYMBOL = 'DUB'
  const COST = web3.utils.toWei('1', 'ether')
  //wait until contract gets deployed
  await deployer.deploy(Land, NAME, SYMBOL, COST)
};
