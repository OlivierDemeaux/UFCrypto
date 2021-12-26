// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract fighter is ERC721, Ownable {

    uint fighterId;
    uint16 public cooldownTime = uint16(5 hours);
    //the fighting styles are "wrestling", "bjj", "boxing", "kickboxing", "mma"

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

    struct Fighter {
        string name;
        uint8 weight;
        uint8 age;
        uint8 level;
        uint8 fightingStyle;
        uint32 xp;
        uint readyTime;
        uint id;
        // by order: strengh, stamina, health, speed, striking, grappling, wrestling, boxing, kicking
        uint8[9] stats;
        bool injured;
    }

    Fighter[] public fighters;

    uint8[9][] public selectedStyle;

    event NewFighter(uint fighterId, string name, uint style);

    mapping (uint => address) public fighterIdToOwner;
    mapping(address => uint) ownerFighterCount;

    modifier onlyOwnerOf(uint _fighterId) {
        require(msg.sender == fighterIdToOwner[_fighterId]);
        _;
  }

    constructor() ERC721("UFCrypto Fighters", "FIGHT") {
        // Preset default stats starting.
        //Will look for a more efficient way of doing this.
        //Starting with wrestler, theb bjj, boxing, striking, and balanced.
        selectedStyle.push([13, 11, 10, 9, 3, 10, 15, 2, 2]); //wrestling heavy style
        selectedStyle.push([11, 13, 10, 9, 2, 15, 10, 3, 2]); //bjj heavy start
        selectedStyle.push([9, 12, 10, 12, 11, 1, 2, 15, 3]); //boxing heavy start
        selectedStyle.push([8, 10, 10, 11, 13, 1, 1, 11, 10]); //striking heavy start
        selectedStyle.push([8, 9, 10, 9, 8, 8, 8, 8, 8]); //balanced start
    }

    function createFighter(string memory _name, uint8 _style) public returns(bool) {
        require(getNumberOfFightersOwned() < 10, "one owner can have max 10 fighters");
        fighters.push(Fighter(_name, 170, 18, 1, _style, 0, block.timestamp, fighterId, selectedStyle[_style], false));
        fighterIdToOwner[fighterId] = msg.sender;
        ownerFighterCount[msg.sender] += 1;
        fighterId += 1;
        emit NewFighter(fighterId, _name, _style);
        return(true);
    }

    //gets a fighter through ID.
    function getFighter(uint _id) public view returns(Fighter memory){
        return(fighters[_id]);
    }

    function _levelUp(uint _fighterId) internal {
        fighters[_fighterId].level += 1;
    }

    function train(uint _fighterId) public onlyOwnerOf(_fighterId) {
        require(_isReady(_fighterId), "not ready to train again");
        require(!fighters[_fighterId].injured, "can't train while injured");
        for(uint i = 0; i < 9; i++) {
            fighters[_fighterId].stats[i]++;
        }
        fighters[_fighterId].xp += 10;
        _checkLevelUp(_fighterId);
        _triggerCooldown(_fighterId);
    }

    function _isReady(uint _fighterId) internal view returns (bool) {
        return (fighters[_fighterId].readyTime <= block.timestamp);
    }

    function _isInjured(uint _fighterId) internal view returns (bool) {
        return (fighters[_fighterId].injured)
    }

    function _checkLevelUp(uint _fighterId) private {
        if(fighters[_fighterId].xp > 8*(fighters[_fighterId].level**3)) {
            fighters[_fighterId].level += 1;
        }
    }

    function _triggerCooldown(uint _fighterId) internal {
        fighters[_fighterId].readyTime = block.timestamp + cooldownTime;
    }

    //Should only ever be called after a "_isInjured()" check
    function _gotInjured(uint _fighterId) internal {
        fighters[_fighterId].injured = false;
    }

    function getFighterStats(uint _fighterId) public view returns(uint8[9] memory) {
        return(fighters[_fighterId].stats);
    } 

    function getNumberOfFightersOwned() public view returns(uint) {
        return(ownerFighterCount[msg.sender]);
    }
}