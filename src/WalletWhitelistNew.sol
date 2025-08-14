// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin-contracts/contracts/access/Ownable.sol";

contract WalletWhitelist is Ownable {
    uint256 public whitelistCount;
    mapping(address => bool) public allowedList;
    mapping(address => bool) public isWhitelisted;

    event WalletAddedToWhitelist(address wallet);
    event WalletRemovedFromWhitelist(address wallet);

    constructor(address[15] memory allowedSet) Ownable(msg.sender) {
        for (uint256 i = 0; i < allowedSet.length; i++) {
            require(allowedSet[i] != address(0), "INVALID WALLET ADDRESS PROVIDED");
            allowedList[allowedSet[i]] = true;
        }
    }

    function addWalletToWhitelist(address wallet) external onlyOwner {
        require(wallet != address(0), "INVALID WALLET ADDRESS PROVIDED");
        require(allowedList[wallet], "WALLET NOT IN ALLOWED LIST");
        require(!isWhitelisted[wallet], "WALLET ALREADY IN WHITELIST");
        require(whitelistCount < 5, "WHITELIST LIMIT REACHED");
        isWhitelisted[wallet] = true;
        whitelistCount++;
        emit WalletAddedToWhitelist(wallet);
    }

    function removeWalletFromWhitelist(address wallet) external onlyOwner {
        require(wallet != address(0), "INVALID WALLET ADDRESS PROVIDED");
        require(isWhitelisted[wallet], "WALLET ALREADY NOT IN WHITELIST");
        isWhitelisted[wallet] = false;
        whitelistCount--;
        emit WalletRemovedFromWhitelist(wallet);
    }

    function isWalletWhitelisted(address wallet) public view returns (bool) {
        require(wallet != address(0), "INVALID WALLET ADDRESS PROVIDED");
        return isWhitelisted[wallet];
    }
}
