// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import "../src/SettlementContract.sol";

contract TestOALScript is Script {
    function run() external {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Addresses and other parameters
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        address recipient = vm.envAddress("RECIPIENT_ADDRESS");
        uint256 tokenId = vm.envUint("TOKEN_ID");

        // Load the deployer's address
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer Address:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        bool allowlistImplemented = false;
        bool failedForOtherReasons = false;

        try new SettlementContract() returns (SettlementContract settlementContract) {
            console.log("Settlement Contract Address:", address(settlementContract));
            try IERC721(tokenAddress).approve(address(settlementContract), tokenId) {
                console.log("Approved SettlementContract to transfer token");
                try settlementContract.transferAsset(tokenAddress, deployer, recipient, tokenId) {
                    console.log("Transferred token to recipient");
                } catch Error(string memory reason) {
                    console.log("Failed to transfer token:", reason);
                    failedForOtherReasons = true;
                } catch (bytes memory lowLevelData) {
                    if (isCustomError(lowLevelData, 0x8371ab02)) {
                        console.log("\x1b[32mFailed to transfer token: The contract is not on the allowlist.\x1b[0m");
                        allowlistImplemented = true;
                    } else {
                        console.log("Failed to transfer token: Low-level error");
                        failedForOtherReasons = true;
                    }
                }
            } catch Error(string memory reason) {
                console.log("Failed to approve SettlementContract:", reason);
                failedForOtherReasons = true;
            } catch (bytes memory lowLevelData) {
                if (isCustomError(lowLevelData, 0x8371ab02)) {
                    console.log("Failed to approve SettlementContract: The contract is not on the allowlist.");
                    allowlistImplemented = true;
                } else {
                    console.log("Failed to approve SettlementContract: Low-level error");
                    failedForOtherReasons = true;
                }
            }
        } catch Error(string memory reason) {
            console.log("Failed to deploy SettlementContract contract:", reason);
            failedForOtherReasons = true;
        } catch (bytes memory) /*lowLevelData*/ {
            // Comment out the variable name
            console.log("Failed to deploy SettlementContract contract: Low-level error");
            failedForOtherReasons = true;
        }

        vm.stopBroadcast();

        // ASCII art messages
        if (allowlistImplemented) {
            console.log("\n\x1b[32m");
            console.log("   _____ _    _  _____ _____ ______  _____ _____ ");
            console.log("  / ____| |  | |/ ____/ ____|  ____|/ ____/ ____|");
            console.log(" | (___ | |  | | |   | |    | |__  | (___| (___  ");
            console.log("  \\___ \\| |  | | |   | |    |  __|  \\___ \\\\___ \\ ");
            console.log("  ____) | |__| | |___| |____| |____ ____) |___) |");
            console.log(" |_____/ \\____/ \\_____\\_____|______|_____/_____/ ");
            console.log("              allowlist implemented.            ");
            console.log("\x1b[0m");
        } else if (!failedForOtherReasons) {
            console.log("\n\x1b[31m");
            console.log("  ___      _____ _     _    _ _____  ______ ");
            console.log(" |  ____/\\   |_   _| |   | |  | |  __ \\|  ____|");
            console.log(" | |__ /  \\    | | | |   | |  | | |__) | |__   ");
            console.log(" |  __/ /\\ \\   | | | |   | |  | |  _  /|  __|  ");
            console.log(" | | / ____ \\ _| |_| |___| |__| | | \\ \\| |____ ");
            console.log(" |_|/_/    \\_\\_____|______\\____/|_|  \\_\\______|");
            console.log("              allowlist not implemented.         ");
            console.log("\x1b[0m");
        }
    }

    function isCustomError(bytes memory lowLevelData, bytes4 errorCode) internal pure returns (bool) {
        if (lowLevelData.length < 4) {
            return false;
        }
        bytes4 receivedErrorCode;
        assembly {
            receivedErrorCode := mload(add(lowLevelData, 0x20))
        }
        return receivedErrorCode == errorCode;
    }
}
