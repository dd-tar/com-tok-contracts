import * as dotenv from 'dotenv'
import { ethers, run } from "hardhat"

import {
  DAOFactory__factory
} from '../typechain-types'
//import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";

dotenv.config()

async function main() {
  const signers = await ethers.getSigners()

  const _rabbit = "..."
  const _freeTrial = 0
  const _subscribitionCost = ethers.utils.parseEther("...")
  const _subscriptionDuration = 0

  const daoFactory = await new DAOFactory__factory(signers[0])
      .deploy()

  await daoFactory.deployed();
  console.log('DAOFactory deployed at: ',  daoFactory.address);

  // verify?
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })