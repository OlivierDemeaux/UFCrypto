const { expect } = require("chai");

describe("Fighter contract", function () {
  it("Deployment should assign owner and create the first fighter", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const Fighter = await ethers.getContractFactory("fighter");

    const hardhatFighter = await Fighter.deploy();

    const checkOwner = await hardhatFighter.owner();
    expect(owner.address).to.be.equal(checkOwner);

    const ownerNumFighters = await hardhatFighter.getNumberOfFightersOwned();
    await expect(ownerNumFighters).to.equal(0);
    
    await hardhatFighter.createFighter("Olivier", 1);

    const ownerNumFightersPost = await hardhatFighter.getNumberOfFightersOwned();
    await expect(ownerNumFightersPost).to.equal(1);

    const olivier = await hardhatFighter.fighters(0);
    expect(olivier[0]).to.be.equal("Olivier");
    expect(olivier[1]).to.be.equal(170);
    expect(olivier[2]).to.be.equal(18);
    expect(olivier[3]).to.be.equal(1);
    expect(olivier[4]).to.be.equal(1);
    expect(olivier[5]).to.be.equal(0);
    expect(olivier[8]).to.be.equal(false);

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