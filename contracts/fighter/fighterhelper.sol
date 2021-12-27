// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./fighterfactory.sol";

contract FighterHelper is FighterFactory {
    
    modifier onlyOwnerOf(uint _fighterId) {
        require(msg.sender == fighterIdToOwner[_fighterId]);
        _;
  }
    function _levelUp(uint _fighterId) internal {
        fighters[_fighterId].level += 1;
    }

    function _triggerCooldown(uint _fighterId) internal {
        fighters[_fighterId].readyTime = block.timestamp + cooldownTime;
    }

    //gets a fighter through ID.
    function getFighter(uint _id) public view returns(Fighter memory){
        return(fighters[_id]);
    }

    //Should only ever be called after a "_isInjured()" check
    function _gotInjured(uint _fighterId) internal {
        fighters[_fighterId].injured = false;
    }

    function getFighterStats(uint _fighterId) public view returns(uint8[9] memory) {
        return(fighters[_fighterId].stats);
    }

    function _isReady(uint _fighterId) internal view returns (bool) {
        return (fighters[_fighterId].readyTime <= block.timestamp);
    }

    function _isInjured(uint _fighterId) internal view returns (bool) {
        return (fighters[_fighterId].injured);
    }

    function _checkLevelUp(uint _fighterId) internal {
        if(fighters[_fighterId].xp > 8*(fighters[_fighterId].level**3)) {
            fighters[_fighterId].level += 1;
        }
    }

}