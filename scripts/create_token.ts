import * as dotenv from 'dotenv'
import { ethers} from "hardhat"

import {
    DAOFactory
} from '../typechain-types'
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
import {Contract} from "ethers";

dotenv.config()

async function main() {
    let creator: SignerWithAddress;
    let daoFactory: Contract;
    [creator] = await ethers.getSigners();

    const daoFactoryProxyAddr = "0x21829BdAcB7d66499EF8bfEA40176E58d69dF7Eb";

    const _name = "Test";
    const _symbol = "TT";
    const _price = 5000000000000000; //ethers.utils.parseEther("0.00005");
    const dao = "0x7A74A18Cc9973ca94BA7b4788A017afe42B05fB2";

    daoFactory = await ethers.getContractAt("DAOFactory", daoFactoryProxyAddr, creator);

    const tx = await daoFactory.createDAOToken(_name, _symbol, _price, dao);
    await tx.wait();

    console.log('DAOToken deployed at:',  tx);

    // verify?
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })