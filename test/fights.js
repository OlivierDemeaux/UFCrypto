const { expect } = require("chai");
const {  BigNumber } = require('ethers');

describe("Test fight logic", function () {
    let Fighter;
    let owner;
    let addr1;
    let hardhatFighter;
  
    beforeEach(async function () {
      [owner, addr1, addr2] = await ethers.getSigners();
      Fighter = await ethers.getContractFactory("Fight");
  
      hardhatFighter = await Fighter.deploy();
      await hardhatFighter.createFighter("Olivier", 1);
      await hardhatFighter.connect(addr1).createFighter("GSP", 0);
    });

    it("check Fighters ownership", async function () {
        expect(await hardhatFighter.balanceOf(owner.address, 2)).to.be.equal(1);
        expect(await hardhatFighter.balanceOf(addr1.address, 3)).to.be.equal(1);
    });

    it("check that the fight can't happen if one fighter is retired", async function() {
        let olivier = await hardhatFighter.fighters(2);
        expect(olivier.status).to.be.equal(0);
        await hardhatFighter.retire(2);
        olivier = await hardhatFighter.fighters(2);
        expect(olivier.status).to.be.equal(4);
        expect(hardhatFighter.fight(2, 3)).to.be.revertedWith("at least one of the fighters is retired and can't compete");
    });

    it("check pre fight record and post fight when Olivier wins and GSP losses", async function() {
        const oliviersRecord = await hardhatFighter.getFightersRecord(0);
        const gspsRecord = await hardhatFighter.getFightersRecord(1);
        expect(oliviersRecord[0]).to.be.equal(0);
        expect(gspsRecord[1]).to.be.equal(0);
        await hardhatFighter.fight(0, 1);
        const oliviersRecordPostFight = await hardhatFighter.getFightersRecord(0);
        const gspsRecordPostFight = await hardhatFighter.getFightersRecord(1); 
        expect(oliviersRecordPostFight[0]).to.be.equal(1);
        expect(gspsRecordPostFight[1]).to.be.equal(1);

        let gspPostFight = await hardhatFighter.fighters(1);
        expect(gspPostFight.injured).to.be.equal(true);
    });
});