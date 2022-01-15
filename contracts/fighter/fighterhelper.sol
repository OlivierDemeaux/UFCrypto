// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./fighterfactory.sol";

contract FighterHelper is FighterFactory {

    uint randNonce = 0;

    event GotInjured(uint fighterId);
    event IncreasedLevel(uint fighterId, uint newLevel);
    
    modifier onlyOwnerOf(uint _fighterId) {
        require(balanceOf(msg.sender, _fighterId) == 1, "Not the rightfull owner of this fighter");
        _;
  }

    modifier aboveLevel(uint _level, uint _fighterId) {
        require(fighters[_fighterId].level >= _level, "Can't do this with your current level");
        _;
  }

    modifier notSameOwner(uint _firstFighterId, uint _secondFighterId) {
        require(balanceOf(msg.sender, _firstFighterId) != balanceOf(msg.sender, _secondFighterId));
        _;
    }

    function _levelUp(uint _fighterId) internal {
        fighters[_fighterId].level += 1;
        emit IncreasedLevel(_fighterId, fighters[_fighterId].level);
    }

    function _triggerCooldown(uint _fighterId) internal {
        fighters[_fighterId].readyTime = block.timestamp + cooldownTime;
    }

    //gets a fighter through ID.
    function getFighter(uint _id) public view returns(Fighter memory){
        return(fighters[_id]);
    }

    function getFightersRecord(uint _id) public view returns(uint8[6] memory) {
        return(fighters[_id].fightRecord);
    }

    //Should only ever be called after a "_isInjured()" check
    function _gotInjured(uint _fighterId) internal {
        fighters[_fighterId].injured = true;
        emit GotInjured(_fighterId);
    }

    function getFighterStats(uint _fighterId) public view returns(uint8[9] memory) {
        return(fighters[_fighterId].stats);
    }

    function getFighterStatus(uint _fighterId) public view returns(pro_status) {
        return(fighters[_fighterId].status);
    }

    function retire(uint _fighterId) public onlyOwnerOf(_fighterId) {
        fighters[_fighterId].status = pro_status(4);
    }

    function checkIfRetired(uint _fighterId) public view returns(bool) {
        if (fighters[_fighterId].status == pro_status(4))
            return(true);
        return(false);
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

    function transferFighter(address _to, uint _fighterId) public onlyOwnerOf(_fighterId) {
        safeTransferFrom(msg.sender, _to, _fighterId, 1, "");
    }

    function getRand() internal returns(uint) {
        return(randMod(100));
    }

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
}