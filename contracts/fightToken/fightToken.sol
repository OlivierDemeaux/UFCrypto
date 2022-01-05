// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract FightToken is ERC20, Ownable {

    uint maxSupply;

    constructor (string memory _name, string memory _symbol, uint _maxSupply)
     public ERC20(_name, _symbol) {
        maxSupply = _maxSupply;
        _mint(msg.sender, 10000);
     }
}