// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract AuthTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    function testSetOwner() public {
        wallet.setOwner(address(1));
        assertEq(wallet.owner(), address(1));
    }

    function testFailNotOwner() public {
        vm.prank(address(1));
        wallet.setOwner(address(1));
    }

    function testFailNotOwnerAgain() public {
        //  msg.sender = address(this)
        wallet.setOwner(address(1));

        vm.startPrank(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(2));

        vm.stopPrank();
        // msg.sender = owner
        wallet.setOwner(address(1));
    }
}
