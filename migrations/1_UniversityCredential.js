var UniversityCredential = artifacts.require("./UniversityCredential.sol");

module.exports = function (deployer) {
  deployer.deploy(UniversityCredential);
};