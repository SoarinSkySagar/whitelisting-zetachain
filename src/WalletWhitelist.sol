// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin-contracts/contracts/access/Ownable.sol";

contract WalletWhitelist is Ownable {

    mapping (address => bool) public isWhitelisted;

    event WalletAddedToWhitelist(address wallet);
    event WalletRemovedFromWhitelist(address wallet);

    constructor(address[5] memory initialList) Ownable(msg.sender) { 
        for (uint i = 0; i < initialList.length; i++) { 
            require(initialList[i] != address(0), "INVALID WALLET ADDRESS PROVIDED"); 
            isWhitelisted[initialList[i]] = true; 
        } 
    }

    function addWalletToWhitelist(address wallet) external onlyOwner {
        require(wallet != address(0), "INVALID WALLET ADDRESS PROVIDED");
        require(!isWhitelisted[wallet], "WALLET ALREADY IN WHITELIST");
        isWhitelisted[wallet] = true;
        emit WalletAddedToWhitelist(wallet);
    }

    function removeWalletFromWhitelist(address wallet) external onlyOwner {
        require(wallet != address(0), "INVALID WALLET ADDRESS PROVIDED");
        require(isWhitelisted[wallet], "WALLET ALREADY NOT IN WHITELIST");
        isWhitelisted[wallet] = false;
        emit WalletRemovedFromWhitelist(wallet);
    }

    function isWalletWhitelisted(address wallet) public view returns (bool) {
        require(wallet != address(0), "INVALID WALLET ADDRESS PROVIDED");
        return isWhitelisted[wallet];
    }
}
