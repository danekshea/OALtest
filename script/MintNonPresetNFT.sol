// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/NFT.sol";

contract NFTDeployScript is Script {
    function run() external {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");

        // Load the deployer's address
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer Address:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the NFT contract
        NFT nft = NFT(tokenAddress);

        // Array of recipient addresses
        address[] memory recipients = new address[](6);
        recipients[0] = 0x069b4848F3f991CA92d3400D40CDDEFaE6a7E549;
        recipients[1] = 0xDF6C7A1b48750F220CF0fAb60A51eCF50049CAe8;
        recipients[2] = 0xE52B84CEa14EDC85CeFC735Ed995B2E021e3a206;
        recipients[3] = 0x0b7786D201f0Aaf0642f02D1fb931907dF6c7e2d;
        recipients[4] = 0x1eD81E094cC225efD6ad4c2e9955e282aD02D2Cf;
        recipients[5] = 0xE98B61832248C698085ffBC4313deB465BE857E7;

        // Mint NFTs to each recipient
        for (uint256 i = 0; i < recipients.length; i++) {
            nft.mintTo(recipients[i]);
        }

        vm.stopBroadcast();
    }
}
