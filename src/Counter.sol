// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract Counter {
    uint256 public count;
        
    function get() public view returns (uint256) {
        return count;
    }

    function increment() public {
        count+=1;
    }

    function decrement()public {
        count -= 1;
    }
}
