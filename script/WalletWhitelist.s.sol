// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {WalletWhitelist} from "../src/WalletWhitelist.sol";

contract WalletWhitelistScript is Script {
    WalletWhitelist public walletWhitelist;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address[5] memory init = [
            0x3d4a6c3a556BeAa19541686D5Abb2d8614eF24B1,
            0x5aD32168e2E4eeD1ac4666a931da82ebd89d2177,
            0xe34c296b3A9E8caa7F72f73B2f13d9dDce4E2427,
            0x9D746EAC0c64d796d387aAa6F82ddadE0cf5E1AE,
            0x275F8Eb1C037E154655e89deeeC7eb67CE5f2e0f
        ];
        walletWhitelist = new WalletWhitelist(init);

        vm.stopBroadcast();
    }
}
