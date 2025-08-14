// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {WalletWhitelist} from "../src/WalletWhitelist.sol";
import {Ownable} from "@openzeppelin-contracts/contracts/access/Ownable.sol";

contract WalletWhitelistTest is Test {
    WalletWhitelist public whitelist;

    address owner = address(this);
    address wallet1 = address(0x111);
    address wallet2 = address(0x222);
    address wallet3 = address(0x333);
    address wallet4 = address(0x444);
    address wallet5 = address(0x555);
    address nonOwner = address(0xBEEF);

    function setUp() public {
        address[5] memory initList = [wallet1, wallet2, wallet3, wallet4, wallet5];
        whitelist = new WalletWhitelist(initList);
    }

    function testConstructorInitializesWhitelist() public view {
        assertTrue(whitelist.isWalletWhitelisted(wallet1));
        assertTrue(whitelist.isWalletWhitelisted(wallet5));
        assertFalse(whitelist.isWalletWhitelisted(address(0xABC)));
    }

    function testAddWalletSuccess() public {
        address newWallet = address(0xAAA);
        whitelist.addWalletToWhitelist(newWallet);
        assertTrue(whitelist.isWalletWhitelisted(newWallet));
    }

    function testCannotAddZeroAddress() public {
        vm.expectRevert(bytes("INVALID WALLET ADDRESS PROVIDED"));
        whitelist.addWalletToWhitelist(address(0));
    }

    function testCannotAddSameAddressTwice() public {
        vm.expectRevert(bytes("WALLET ALREADY IN WHITELIST"));
        whitelist.addWalletToWhitelist(wallet1);
    }

    function testOnlyOwnerCanAdd() public {
        vm.prank(nonOwner);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, nonOwner));
        whitelist.addWalletToWhitelist(address(0xAAA));
    }

    function testRemoveWalletSuccess() public {
        whitelist.removeWalletFromWhitelist(wallet1);
        assertFalse(whitelist.isWalletWhitelisted(wallet1));
    }

    function testCannotRemoveZeroAddress() public {
        vm.expectRevert(bytes("INVALID WALLET ADDRESS PROVIDED"));
        whitelist.removeWalletFromWhitelist(address(0));
    }

    function testCannotRemoveAddressNotInWhitelist() public {
        address notListed = address(0xABC);
        vm.expectRevert(bytes("WALLET ALREADY NOT IN WHITELIST"));
        whitelist.removeWalletFromWhitelist(notListed);
    }

    function testOnlyOwnerCanRemove() public {
        vm.prank(nonOwner);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, nonOwner));
        whitelist.removeWalletFromWhitelist(wallet1);
    }

    function testIsWalletWhitelistedRevertsOnZeroAddress() public {
        vm.expectRevert(bytes("INVALID WALLET ADDRESS PROVIDED"));
        whitelist.isWalletWhitelisted(address(0));
    }
}
