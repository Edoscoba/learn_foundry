// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "forge-std/console.sol";

contract SendEther {
    address payable public owner;

    event Deposit(address account, uint256 amount);

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "not the owner");
        payable(owner).transfer(amount);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "not the owner");
        owner = payable(_owner);
        console.log("new owner", _owner);
    }
}
