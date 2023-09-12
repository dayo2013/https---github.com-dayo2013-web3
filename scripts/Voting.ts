import { ethers } from "hardhat";

async function main() {
  const [signer1, signer2, signer3, signer4, signer5] =
    await ethers.getSigners();
  const votingApp = await ethers.getContractAt(
    "IVoting",
    "0x5FbDB2315678afecb367f032d93F642f64180aa3",
  );

  await votingApp.createParticipant(45, "Tola", signer2.address);
  const participant = await votingApp.getParticpantData(signer2.address);

  console.log(participant);
  const participantLength = await votingApp.getParticpantLength();

  console.log(participantLength);

  await votingApp.connect(signer4).vote(signer2.address, 2);

  const votersLength = await votingApp.getVoterLength();
  console.log(votersLength);

  const voterData = await votingApp.getVoterLength();
  console.log(voterData);

  await votingApp.connect(signer5).vote(signer2.address, 2);

  const participantLength2 = await votingApp.getParticpantlength();

  console.log(participantLength2);
}

// We recommend this pattern to be able to use async/await everywhere 0x5FbDB2315678afecb367f032d93F642f64180aa3
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});