const { expect } = require("chai");

describe("Fighter contract", function () {
  it("Deployment should assign owner and create the first fighter", async function () {
    const [owner] = await ethers.getSigners();

    const Fighter = await ethers.getContractFactory("fighter");

    const hardhatFighter = await Fighter.deploy();


    const ownerNumFighters = await hardhatFighter.getNumberOfFightersOwned();
    
    await hardhatFighter.createFighter("Olivier", 1);

    const ownerNumFightersPost = await hardhatFighter.getNumberOfFightersOwned();
    
    expect(ownerNumFighters).to.equal(0);
    expect(ownerNumFightersPost).to.equal(1);
  });
});