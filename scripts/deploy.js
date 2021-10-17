// async function main() {
//   const [deployer] = await ethers.getSigners();

//   console.log("Deploying contracts with the account", deployer.address);

//   console.log("Account balance:", (await deployer.getBalance()).toString());

//   const Token = await ethers.getContractFactory("WavePortal");
//   const token = await Token.deploy();

//   console.log("WavePortal address:", token.address);
// }

async function main() {
  const waveContractFactory = await ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: ethers.utils.parseEther("0.01"),
  });
  await waveContract.deployed();
  console.log("WavePortal address: ", waveContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
