// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "forge-std/console.sol";

contract Auction {
    uint256 public startAt = block.timestamp + 1 days;
    uint256 public endAt = block.timestamp + 2 days;

    function bid() public view {
        require(block.timestamp >= startAt && block.timestamp < endAt, "cannot bid");
        console.log(startAt);
    }

    function end() external view {
        require(block.timestamp >= endAt, "cannot end");
        console.log(endAt);
    }
}
