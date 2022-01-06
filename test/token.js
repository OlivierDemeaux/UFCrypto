const { expect } = require("chai");
const {  BigNumber } = require('ethers');

describe("fightToken ERC20 tests", async function () {

    beforeEach( async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        Token = await ethers.getContractFactory("FightToken");
        hardhatToken = await Token.deploy("fight", "FGHT", 1000000);
    })
    
    it("Owner should get 10 000 FIGHT token", async function () {
      expect(await hardhatToken.balanceOf(owner.address)).to.be.equal(10000);
    });
  });