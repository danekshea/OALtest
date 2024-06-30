// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
}

contract SettlementContract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function transferAsset(address token, address from, address to, uint256 tokenId) external {
        require(msg.sender == owner, "Not authorized");
        IERC721(token).transferFrom(from, to, tokenId);
    }
}
