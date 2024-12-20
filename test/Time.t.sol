// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Auction} from "../src/Time.sol";
import "forge-std/console.sol";

contract TimeTest is Test {
    Auction public auction;
    uint256 private startAt;

    // vm.wap --- set block.timestamp to future timestamp
    // vm.roll --- set block.number
    // skip --- increment current timestamp

    function setUp() public {
        auction = new Auction();
        startAt = block.timestamp;
    }

    function testBidFailsBeforeStartTime() public {
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    function testBid() public {
        vm.warp(startAt + 1 days);
        auction.bid();
    }

    function testBidFailsAfterEndTime() public {
        vm.expectRevert(bytes("cannot bid"));
        vm.warp(startAt + 2 days);
        auction.bid();
    }

    function testTimestamp() public {
        uint256 t = block.timestamp;

        // skip - increment current timestamp
        skip(100);
        assertEq(block.timestamp, t + 100);

        // rewind - decrement current timestamp
        rewind(10);
        assertEq(block.timestamp, t + 100 - 10);
    }

    function testBlockNumber() public {
        // uint256 time = block.number;

        vm.roll(999);
        assertEq(block.number, 999);
    }
}
