// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/NFT.sol";

contract NFTDeployScript is Script {
    function run() external {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address recipient = vm.envAddress("RECIPIENT_ADDRESS");
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");

        // Load the deployer's address
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer Address:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the NFT contract
        NFT nft = NFT(tokenAddress);

        nft.mintTo(recipient);

        vm.stopBroadcast();
    }
}
