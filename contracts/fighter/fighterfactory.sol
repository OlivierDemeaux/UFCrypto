// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract FighterFactory is Ownable, ERC721Enumerable{

    uint16 public cooldownTime = uint16(5 hours);
    enum pro_status {hopeful, amateur, semiPro, professional, retired }


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
        // fightRecord is an array of 6 values, 3 pairs of win - losses for amateur, semi-pro and pro fighting career.
        uint8[6] fightRecord;
        bool injured;
        pro_status status;
    }

    Fighter[] public fighters;
    mapping (uint256 => address) public fighterIdToOwner;

    // Optional mapping for token URIs
    mapping (uint256 => string) private _tokenURIs;

    uint8[9][] public selectedStyle;
    
    event NewFighter(uint fighterId, string name, uint style);

    constructor() ERC721("UFCrypto Fighters", "FGHTER") {
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
        require(balanceOf(msg.sender) < 10, "one owner can have max 10 fighters");
        uint fighterId = totalSupply();
        fighters.push(Fighter(_name, 170, 18, 1, _style, 0, block.timestamp, fighterId, selectedStyle[_style], [0,0,0,0,0,0], false, pro_status.hopeful));
        _mint(msg.sender, fighterId);
        _tokenURIs[fighterId] = "https://gateway.pinata.cloud/ipfs/QmVLVq6i9Jrok3KWVwZL1Wwmm4beKHmdSjTxajfoBKCVsF";

        return(true);
    }

    function getFighterURI(uint _fighterId) public view returns(string memory) {
        return(_tokenURIs[_fighterId]);
    }
}