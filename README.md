## TestOAL

Foundry scripts for testing the implementation of the operator allowlist. Works by deploying a simple settlment contract that and tries to grant approval and tranfser to the contract for an asset.

## Instructions

1. Make sure Foundry is installed: (https://getfoundry.sh)
2. Ask the partner to deploy the contract on testnet and verify it.
3. Ask them to transfer an NFT to an address you control and can put the private key in the .env file.
4. Copy .env.example to .env and populate the values.
5. Run the script with `forge script script/TestOAL.s.sol`
6. You'll get clear ASCII art that indicates whether the OAL was implemented properly or not.
