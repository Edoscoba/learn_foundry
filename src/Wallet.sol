// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "forge-std/console.sol";

contract Wallet {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw() external {
        require(msg.sender == owner, "not the owner");
        uint256 bal = address(this).balance;
        payable(owner).transfer(bal);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "not the owner");
        owner = payable(_owner);
        console.log("new owner", _owner);
    }
}
