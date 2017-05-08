pragma solidity ^0.4.1;


/** @title Vote app **/
contract Vote {

    struct validator {
    address addr;
    string name;
    }

    struct votee {
    address addr;
    uint[] voters_index;
    string name;
    uint created;
    }


    validator[] private validators;

    votee[] private not_confirmed_validators;

    uint private vote_days_min;

    uint private vote_days_max;

    uint80 constant private None = uint80(- 1);

    function Vote(uint min_vote_days, uint max_vote_days, string owner_name){
        validator memory owner = validator(msg.sender, owner_name);

        vote_days_min = min_vote_days;
        vote_days_max = max_vote_days;

        validators.push(owner);
    }


    /** constructor
    * @param votee_addr - address of new potential validator
    **/
    function voteValidator(address votee_addr) {

        bool valid_voter_addr = false;
        uint votee_index = None;
        uint voter_index = None;

        // make sure, that votee is registered in not confirmed validators
        for (uint v = 0; v < not_confirmed_validators.length; v++) {
            if (not_confirmed_validators[v].addr == votee_addr) {
                votee_index = v;
                v = not_confirmed_validators.length;
            }
        }

        // validate votee by index and creation time (if expired - then just skip him)
        if (votee_index == None || (now != 0 && (
        not_confirmed_validators[votee_index].created + vote_days_min * 1 days < now ||
        not_confirmed_validators[votee_index].created + vote_days_max * 1 days > now))) {
            delete not_confirmed_validators[votee_index];
            return;
        }

        for (uint i = 0; i < validators.length; i++) {

            // check if votee is not among validators
            if (validators[i].addr == votee_addr) {
                valid_voter_addr = false;
                i = validators.length;
            }

            // find validator and check if he is not already voted
            if (validators[i].addr == msg.sender) {
                valid_voter_addr = true;
                voter_index = i;
                for (uint s = 0; s < not_confirmed_validators[votee_index].voters_index.length && valid_voter_addr; s++) {
                    if (not_confirmed_validators[votee_index].voters_index[s] == i) {
                        valid_voter_addr = false;
                    }
                }
            }
        }


        // if all is fine - then if 50% or more voted for invitee -> he becomes validator,
        // otherwise, just update voter's list for current invitee
        if (valid_voter_addr) {
            if (validators.length == 1 ||
            (not_confirmed_validators[votee_index].voters_index.length != 0 &&
            not_confirmed_validators[votee_index].voters_index.length * 100 / validators.length >= 50)) {
                validator memory val = validator(votee_addr, not_confirmed_validators[votee_index].name);
                delete not_confirmed_validators[votee_index];
                validators.push(val);
            }
            else {
                not_confirmed_validators[votee_index].voters_index.push(voter_index);
            }

        }


    }


    /** add potential validator **/
    function addValidator(address addr, string name) {
        if (addr != address(0) && bytes(name).length != 0) {
            bool is_set = false;
            votee memory val = votee(addr, new uint[](0), name, now);

            for (uint i = 0; i < not_confirmed_validators.length; i++) {
                if (not_confirmed_validators[i].addr == address(0)) {
                    not_confirmed_validators[i] = val;
                    is_set = true;
                }
            }
            if (!is_set) {
                not_confirmed_validators.push(val);
            }
        }
    }

    /** get votees list **/
    function getVotees() constant returns (address[]) {

        address[] addresses;

        for (uint i = 0; i < not_confirmed_validators.length; i++) {
            if (not_confirmed_validators[i].addr != address(0))
            addresses.push(not_confirmed_validators[i].addr);
        }

        return addresses;
    }

    /** get amount of validators **/
    function getValidatorsCount() constant returns (uint) {
        return validators.length;
    }


}