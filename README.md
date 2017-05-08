# S7 showcase

Vote contract written in solidity Solidity, and running on Ethereum.

Features:
  - Add new validator
  - Vote for potential validator
  - Get potential validators list

### Installation

The first step will be installation of truffle (which is used as contract management system):
```sh
npm install -g truffle
```

Next install ethereum (you can use docker image included):
```sh
cd docker
docker build . -t ethereum/local
docker run -d --name ethereum -p 8548:8545 -p 30303:30303 ethereum/local
```

Or just install and run testrpc:

```sh
npm install -g ethereumjs-testrpc
testrpc
```

Finally, compile and deploy contracts:

```sh
cd contracts
truffle compile
truffle migrate
```


### Testing
Truffle is shipped with it's own testing system, so you just need to call it from contracts dir:

```sh
cd contracts
truffle test
```

### Interfaces

Contract interfaces:

| Interface | params | description|
| ------ | ------ |  ------ |
| Vote[constructor]   | min_vote_days [uint], max_vote_days[uint], owner_name[string] | constructor, create contract, with set min and max voting days for every new potential voter
| addValidator   | user_addr [address], username [string] | adds new potential validator
| voteValidator   | votee_addr [address] | vote for potential validator
| getVotees   |  | get potential validators list
| getValidatorsCount   |  | get amount of validators


License
----

MIT