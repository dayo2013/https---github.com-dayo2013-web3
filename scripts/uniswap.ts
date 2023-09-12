import { ethers, network } from 'hardhat'

async function main(){


    const uniswap = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D'
    const unifactory = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"
    const uniContract = await ethers.getContractAt("Iuniswap","uniswap")
    const uniswapfactory = await ethers.getContractAt("Iuniswap","unifactory")

    const DAI = '0x6B175474E89094C44Da98b954EedeAC495271d0F'
    const UNI = '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984'

    const  holder = "0x20bB82F2Db6FF52b42c60cE79cDE4C7094Ce133F"
    
    const signer = await ethers.getImpersonatedSigner(holder)
    const DAIcontract = await ethers.getContractAt("IERC20","DAIcontract")
    const UNIcontract = await ethers.getContractAt("IERC20","UNI")

    const addLiquidity = await uniswap .connect(UNIDAISigner)
    .addLiquidity(
     UNI,
     DAI,
     amountADesired,
     amountBDesired,
     amountAMin,
     amountBMin,
     UsdcDaiWhale,
     deadline
    );
    await txaddLiqiudity.wait();
    console.log("Transaction hash:", txaddLiqiudity.hash);












}