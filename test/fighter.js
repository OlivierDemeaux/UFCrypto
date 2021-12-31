const { expect } = require("chai");
const {  BigNumber } = require('ethers');

describe("Fighter contract", function () {

  let Fighter;
  let owner;
  let addr1;
  let addre2;
  let hardhatFighter;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    Fighter = await ethers.getContractFactory("Fighter");

    hardhatFighter = await Fighter.deploy();
    await hardhatFighter.createFighter("Olivier", 1);

  });
  describe("Deployement and Owner assign", function() {
    it("Should assign correct owner", async function () {
      const checkOwner = await hardhatFighter.owner();
      expect(owner.address).to.be.equal(checkOwner);
  });
});

  describe("Fighter Creation", function() {
    it("Should have created one Fighter", async function() {
      const ownerNumFightersPost = await hardhatFighter.getNumberOfFightersOwned();
      await expect(ownerNumFightersPost).to.equal(1);
    });

    it("Fighter created should have the correct caracteristics", async function() {
      const olivier = await hardhatFighter.fighters(0);
      expect(olivier[0]).to.be.equal("Olivier");
      expect(olivier[1]).to.be.equal(170);
      expect(olivier[2]).to.be.equal(18);
      expect(olivier[3]).to.be.equal(1);
      expect(olivier[4]).to.be.equal(1);
      expect(olivier[5]).to.be.equal(0);
      expect(olivier[10]).to.be.equal(false);
    })

    it("Fighter created should have the correct stats", async function() {
      const olivierStats =  await hardhatFighter.getFighterStats(0)

      //Check that fighter stats were initialized correctly.
      expectedArray = [11, 13, 10, 9, 2, 15, 10, 3, 2]
      expect(olivierStats[0]).to.be.equal(expectedArray[0]);
      expect(olivierStats[1]).to.be.equal(expectedArray[1]);
      expect(olivierStats[2]).to.be.equal(expectedArray[2]);
      expect(olivierStats[3]).to.be.equal(expectedArray[3]);
      expect(olivierStats[4]).to.be.equal(expectedArray[4]);
      expect(olivierStats[5]).to.be.equal(expectedArray[5]);
      expect(olivierStats[6]).to.be.equal(expectedArray[6]);
      expect(olivierStats[7]).to.be.equal(expectedArray[7]);
      expect(olivierStats[8]).to.be.equal(expectedArray[8]);
    });
  });

  describe("Limit number of Fighters owned by one address", function() {
    it("Should fail if one address tries to create more than 10fighters", async function () {
      // create 9 new fighters so that Owner has 10 fighters
      var i = 0;
      while(i < 9) {
        await hardhatFighter.createFighter("Olivier", 1);
        i++;
      }

     await expect(hardhatFighter.createFighter("Olivier", 1)).to.revertedWith(
       "one owner can have max 10 fighters");
    });
  });

  describe("Train", function() {
    let preTrainingOlivier;
    let postTrainingOlivier;
    let preTrainingStats;
    let postTrainingStats;
    beforeEach(async function () {
      preTrainingOlivier = await hardhatFighter.fighters(0);
      preTrainingStats = await hardhatFighter.getFighterStats(0);
      await hardhatFighter.train(0)
      postTrainingOlivier = await hardhatFighter.fighters(0);
      postTrainingStats = await hardhatFighter.getFighterStats(0);
      
    })
    it("Calling train() should have increased Olivier's stats per 1 each", async function () {
      //Check that fighter stats were increased correctly each value by 1.
      expectedArray = [12, 14, 11, 10, 3, 16, 11, 4, 3]
      postTrainingStats =  await hardhatFighter.getFighterStats(0)
      var i = 0;
      while(i < 9) {
        expect(preTrainingStats[i] + 1).to.be.equal(postTrainingStats[i]);
        i++;
      }
    });
    it("Calling train() should have increased Olivier's cooldownTime", async function () {
      //Calling train() should have increased readyTime
      expect(postTrainingOlivier.readyTime).to.be.above(preTrainingOlivier.readyTime);
    });

    it("Olivier's lvl should have increased", async function () {
      //Calling train() should have called _checkLevelUp() and Olivier's lvl should have increased
      expect(preTrainingOlivier.level).to.be.below(postTrainingOlivier.level);
    });

    it("Shouldn't be able to call train() again because of readyTime", async function () {
      expect(hardhatFighter.train(0)).to.be.revertedWith("not ready to train again");
    });
  });
});