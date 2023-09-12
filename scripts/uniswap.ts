
import { ethers } from "hardhat";
// import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';

async function main() {
  const uniswapv2 = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
  const uniswapv2Factory = "0x5c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f";
  const uniswapv2Contract = await ethers.getContractAt("IUniswapV2", uniswapv2);
  const uniswapv2FactoryContract = await ethers.getContractAt(
    "IUniswapV2Factory",
    uniswapv2Factory
  );

//   125,516.3579
//   7647.9
  const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
  const UNI = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";

  const holder = "0x20bB82F2Db6FF52b42c60cE79cDE4C7094Ce133F";
  const signer = await ethers.getImpersonatedSigner(holder);

  const DAIContract = await ethers.getContractAt("IERC20", DAI);
  const UNIContract = await ethers.getContractAt("IERC20", UNI);

    await DAIContract.connect(signer).approve(
      uniswapv2,
      ethers.parseEther("1000000")
    );
    await UNIContract.connect(signer).approve(
      uniswapv2,
      ethers.parseEther("1000000")
    );

  //   balance before
  console.log({
    DAIBal: ethers.formatEther(await DAIContract.balanceOf(holder)),
    UNIBal: ethers.formatEther(await UNIContract.balanceOf(holder)),
  });

  const aDes = ethers.parseEther("10");
  const bDes = ethers.parseEther("20");
  const aMin = ethers.parseEther("0");
  const bMin = ethers.parseEther("0");
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const deadline = currentTimestampInSeconds + 3600;

  const pair = await uniswapv2FactoryContract.connect(signer).getPair(DAI, UNI);
  const pairContract = await ethers.getContractAt("IERC20", pair);
  const liquidity = await pairContract.balanceOf(holder);

//   await pairContract
//     .connect(signer)
//     .approve(uniswapv2, ethers.parseEther("1000000"));

    const addLiq = await uniswapv2Contract
      .connect(signer)
      .addLiquidity(DAI, UNI, aDes, bDes, aMin, bMin, signer, deadline);
    addLiq.wait();

//   const remLiq = await uniswapv2Contract
//     .connect(signer)
//     .removeLiquidity(DAI, UNI, liquidity, aMin, bMin, signer, deadline);
//   remLiq.wait();

  //   balance after
  console.log({
    DAIBal: ethers.formatEther(await DAIContract.balanceOf(holder)),
    UNIBal: ethers.formatEther(await UNIContract.balanceOf(holder)),
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});