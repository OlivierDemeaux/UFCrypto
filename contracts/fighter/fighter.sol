// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./fighterhelper.sol";

contract Fighter is FighterHelper {

    // enum WeightClass {
    //     Heavyweight,
    //     LightHeavyweight,
    //     Middleweight,
    //     Welterweight,
    //     Lightweight,
    //     Featherweight,
    //     Bantamweight,
    //     Flyweight,
    //     Strawweight
    // }

    uint randNonce = 0;

    function train(uint _fighterId) public onlyOwnerOf(_fighterId) {
        require(_isReady(_fighterId), "not ready to train again");
        require(!_isInjured(_fighterId), "can't train while injured");
    
        for(uint i = 0; i < 9; i++) {
            fighters[_fighterId].stats[i]++;
        }
        fighters[_fighterId].xp += 10;
        _checkLevelUp(_fighterId);
        _triggerCooldown(_fighterId);

        uint rand = randMod(100);
        if (rand <= 3)
            _gotInjured(_fighterId);
    }

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
}