const Vote = artifacts.require("./Vote.sol");

contract('Vote', function(accounts) {

  it("should create new Vote contract", function() {
    return Vote.new(0, 15, 'super user')
      .then((instance) => {
        assert.isString(instance.address, "contract address");
      });
  });

  it("should add new validator", function() {
    return Vote.deployed()
      .then(instance =>
        instance.addValidator(accounts[1], "name")
      );
  });

  it("should add second validator", function() {
    return Vote.deployed()
      .then(instance =>
        instance.addValidator(accounts[2], "name 2")
      );
  });

  it("should get 2 votees", function() {
    return Vote.deployed()
      .then((instance) =>
        instance.getVotees()
      )
      .then(result => {
        assert.include(result, accounts[1], 'tx contains first votee');
        assert.include(result, accounts[2], 'tx contains second votee');
      })
  });

  it("should vote for first validator", function() {
    return Vote.deployed()
      .then(instance =>
        instance.voteValidator(accounts[1])
      )
  });

  it("should get validator's count", function() {
    return Vote.deployed()
      .then(instance =>
        instance.getValidatorsCount()
      )
      .then(data => {
        assert.equal(data.toString(10), '2', 'check validators count');
      })
  });


  it("should get only second votee", function() {
    return Vote.deployed()
      .then((instance) =>
        instance.getVotees()
      )
      .then(result => {
        assert.notInclude(result, accounts[1], 'tx doesn\'t contain first votee');
        assert.include(result, accounts[2], 'tx contains second votee');
      })
  });

});
