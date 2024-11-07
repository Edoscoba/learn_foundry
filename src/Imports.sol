// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import "../lib/solmate/src/tokens/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20("edoscoba", "EDO", 6){}

contract Test2 is Ownable(msg.sender){}

