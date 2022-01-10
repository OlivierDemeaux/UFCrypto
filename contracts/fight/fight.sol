// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "../fighter/fighter.sol";

contract Fight is Fighter {

    function fight(uint _firstFighterId, uint _secondFighterId) public onlyOwner() notSameOwner(_firstFighterId, _secondFighterId){
        require(fighters[_firstFighterId].injured != true && fighters[_secondFighterId].injured != true);
        require(fighters[_firstFighterId].status != pro_status(4) && fighters[_secondFighterId].status != pro_status(4),
         "at least one of the fighters is retired and can't compete");

        fighters[_firstFighterId].fightRecord[0] += 1;
        fighters[_secondFighterId].fightRecord[1] += 1;
        fighters[_firstFighterId].xp += 50 * fighters[_secondFighterId].level;
        fighters[_secondFighterId].xp += 10 * fighters[_firstFighterId].level;
        _checkLevelUp(_firstFighterId);
        _checkLevelUp(_secondFighterId);


        if (getRand() <= 100)
            _gotInjured(_secondFighterId);
    }
}