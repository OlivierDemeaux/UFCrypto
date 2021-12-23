// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract fighter {

    uint fighterID;

    enum FightingStyle {
        wrestling,
        bjj,
        boxing,
        kickboxing,
        mma
    }

    enum WeightClass {
        Heavyweight,
        LightHeavyweight,
        Middleweight,
        Welterweight,
        Lightweight,
        Featherweight,
        Bantamweight,
        Flyweight,
        Strawweight
    }

    struct Fighter {
        string name;
        uint8 weight;
        uint8 age;
        uint8 level;
        uint32 xp;
        uint id;
        uint8 fightingStyle;
        // by order: strengh, stamina, health, speed, striking, grappling, wrestling, boxing, kicking
        uint8[9] stats;
        bool injured;
    }

    Fighter[] public fighters;

    // bool[2][] public flags;
    // flags.push([true,true]);

    uint8[9][] public selectedStyle;


    mapping (uint => address) public fighterIdToOwner;
    mapping(address => uint) ownerFighterCount;

    constructor()  {
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
        fighters.push(Fighter(_name, 170, 18, 1, 0, fighterID, _style, selectedStyle[_style], false));
        fighterIdToOwner[fighterID] = msg.sender;
        ownerFighterCount[msg.sender]++;
        fighterID++;
        return(true);
    }

    //gets a fighter through ID.
    function getFighter(uint _id) public view returns(Fighter memory){
        return(fighters[_id]);
    }

    function getNumberOfFightersOwn() public view returns(uint) {
        return(ownerFighterCount[msg.sender]);
    }


}