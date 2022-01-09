// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "../fighter/fighter.sol";

contract Fight is Fighter {

    function fight(uint _firstFighterId, uint _secondFighterId) public notSameOwner(_firstFighterId, _secondFighterId) returns(bool){
        
        fighters[_firstFighterId].fightRecord[0] += 1;
        fighters[_secondFighterId].fightRecord[1] += 1;
        return(true);
    }
}