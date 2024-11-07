// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/console.sol";

contract Counter {
    uint256 public count;

    function get() public view returns (uint256) {
        return count;
    }

    function increment() public {
        console.log("here", count);
        count += 1;
    }

    function decrement() public {
        count -= 1;
    }
}
