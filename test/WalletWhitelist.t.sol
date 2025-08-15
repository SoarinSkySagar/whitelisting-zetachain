// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {WalletWhitelist} from "../src/WalletWhitelist.sol";
import {Ownable} from "@openzeppelin-contracts/contracts/access/Ownable.sol";

contract WalletWhitelistTest is Test {
    WalletWhitelist whitelist;
    address owner = address(0xABCD);
    address attacker = address(0xBEEF);

    address[15] allowedSet = [
        address(0x3d4a6c3a556BeAa19541686D5Abb2d8614eF24B1),
        address(0x5aD32168e2E4eeD1ac4666a931da82ebd89d2177),
        address(0xe34c296b3A9E8caa7F72f73B2f13d9dDce4E2427),
        address(0x9D746EAC0c64d796d387aAa6F82ddadE0cf5E1AE),
        address(0x275F8Eb1C037E154655e89deeeC7eb67CE5f2e0f),
        address(0xB188a44D2b5353f7612a9Fe8b8Cd30e808cd203a),
        address(0xd53330Af78f0dbA6944EB69Fe035055951abD688),
        address(0xf0a835C794Ee167C882aeafa584d22fa7375C27a),
        address(0xF26eeF92A0Aca12D5f239B1De6ee19150443B3FF),
        address(0xa85d058C53216Fb911C60c1D97C6FE1bac5849bB),
        address(0xC92EfB5E88Ad314aa2C329360E045f0C4fc3dC76),
        address(0xc6D0A10cf4163a73648FF051928e50974e34b2D4),
        address(0xc562e60F13098805d62E2102D488C212ae00aF66),
        address(0xd3ab09900a1d15d2E4Fe0A29c19de6E5a83EA900),
        address(0xE073CBb4f6A63B8Ce2de69e8eF7efb67e8392bB3)
    ];

    function setUp() public {
        vm.prank(owner);
        whitelist = new WalletWhitelist(allowedSet);
    }

    function testAddWalletSuccess() public {
        address wallet = allowedSet[0];
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit WalletWhitelist.WalletAddedToWhitelist(wallet);
        whitelist.addWalletToWhitelist(wallet);
        assertTrue(whitelist.isWalletWhitelisted(wallet));
        assertEq(whitelist.whitelistCount(), 1);
    }

    function testRemoveWalletSuccess() public {
        address wallet = allowedSet[1];
        vm.startPrank(owner);
        whitelist.addWalletToWhitelist(wallet);
        vm.expectEmit(true, false, false, true);
        emit WalletWhitelist.WalletRemovedFromWhitelist(wallet);
        whitelist.removeWalletFromWhitelist(wallet);
        vm.stopPrank();
        assertFalse(whitelist.isWalletWhitelisted(wallet));
        assertEq(whitelist.whitelistCount(), 0);
    }

    function testOnlyOwnerCanAdd() public {
        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, attacker));
        whitelist.addWalletToWhitelist(allowedSet[2]);
    }

    function testOnlyOwnerCanRemove() public {
        vm.startPrank(owner);
        whitelist.addWalletToWhitelist(allowedSet[3]);
        vm.stopPrank();
        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, attacker));
        whitelist.removeWalletFromWhitelist(allowedSet[3]);
    }

    function testCannotAddZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert(bytes("INVALID WALLET ADDRESS PROVIDED"));
        whitelist.addWalletToWhitelist(address(0));
    }

    function testCannotRemoveZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert(bytes("INVALID WALLET ADDRESS PROVIDED"));
        whitelist.removeWalletFromWhitelist(address(0));
    }

    function testCannotAddAddressNotInAllowedList() public {
        address random = address(0x999);
        vm.prank(owner);
        vm.expectRevert(bytes("WALLET NOT IN ALLOWED LIST"));
        whitelist.addWalletToWhitelist(random);
    }

    function testCannotAddSameAddressTwice() public {
        address wallet = allowedSet[4];
        vm.startPrank(owner);
        whitelist.addWalletToWhitelist(wallet);
        vm.expectRevert(bytes("WALLET ALREADY IN WHITELIST"));
        whitelist.addWalletToWhitelist(wallet);
        vm.stopPrank();
    }

    function testCannotRemoveAddressNotInWhitelist() public {
        address wallet = allowedSet[5];
        vm.prank(owner);
        vm.expectRevert(bytes("WALLET ALREADY NOT IN WHITELIST"));
        whitelist.removeWalletFromWhitelist(wallet);
    }

    function testWhitelistLimit() public {
        vm.startPrank(owner);
        for (uint256 i = 0; i < 5; i++) {
            whitelist.addWalletToWhitelist(allowedSet[i]);
        }
        vm.expectRevert(bytes("WHITELIST LIMIT REACHED"));
        whitelist.addWalletToWhitelist(allowedSet[6]);
        vm.stopPrank();
    }

    function testWhitelistCountAccuracy() public {
        vm.startPrank(owner);
        whitelist.addWalletToWhitelist(allowedSet[7]);
        whitelist.addWalletToWhitelist(allowedSet[8]);
        whitelist.removeWalletFromWhitelist(allowedSet[7]);
        vm.stopPrank();
        assertEq(whitelist.whitelistCount(), 1);
    }

    function testIsWalletWhitelistedViewFunction() public {
        address wallet = allowedSet[9];
        vm.startPrank(owner);
        whitelist.addWalletToWhitelist(wallet);
        vm.stopPrank();
        assertTrue(whitelist.isWalletWhitelisted(wallet));
    }

    function testIsWalletWhitelistedRevertsOnZeroAddress() public {
        vm.expectRevert(bytes("INVALID WALLET ADDRESS PROVIDED"));
        whitelist.isWalletWhitelisted(address(0));
    }
}
