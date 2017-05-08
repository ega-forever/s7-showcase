const Vote_contract = artifacts.require("./Vote.sol"),
 Migrations = artifacts.require("./Migrations.sol");


module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Vote_contract);
};
