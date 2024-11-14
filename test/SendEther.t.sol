// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SendEther} from "../src/SendEther.sol";
// Examples of deal and hoax
// deal(address, uint) -- set balance of address
// hoax(address,uint) -- deal + prank, sets up a prank and set balance

contract sendEtherTest is Test {
    SendEther public sendEther;

    function setUp() public {
        sendEther = new SendEther{value: 1e18}();
    }

    function _send(uint256 amount) private {
        (bool ok,) = address(sendEther).call{value: amount}("");
        require(ok, " send ETH failed");
    }

    function testEthBalance() public view {
        console.log("ETH balance", address(this).balance / 1e18);
    }

    function testSendEth() public {
        // deal(address, uint) -- set balance of address
        deal(address(1), 100);
        assertEq(address(1).balance, 100);

        // hoax(address, uint) -- deal + prank, Sets up a prank and set balance
        deal(address(1), 123);
        vm.prank(address(1));
        _send(123);

        // hoax
        hoax(address(1),456);
        _send(456);
    }
}
