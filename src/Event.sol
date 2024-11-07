// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract Event {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function transfer(address from, address to, uint256 amount) public {
        emit Transfer(from, to, amount);
    }

    function transferForMany(address from, address[] calldata to, uint256[] calldata amounts) public {
        for (uint256 i = 0; i < to.length; i++) {
            emit Transfer(from, to[i], uint256(amounts[i]));
        }
    }
}
