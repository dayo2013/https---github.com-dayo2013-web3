import { ethers } from "hardhat";

async function main(){


    const Vote = await ethers.getContractAt('voting', "vote");


const Votes = await ethers.deployContract("votes", [], {
    
  });


  await Vote.waitForDeployment()
  
    }


  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  