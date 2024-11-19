// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC20} from "../src/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply)
        ERC20(_name, _symbol, _decimals, _totalSupply)
    {}

    function mint(address _to, uint256 _amount) external {
        _mint(_to, _amount);
    }

    function burn(uint256 _amount) external {
        _burn(msg.sender, _amount);
    }
}

contract TokenScript is Script {
    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address account = vm.addr(privateKey);
        console.log("Account:", account);
        vm.startBroadcast(privateKey);
        // deploy token
        Token token = new Token("Test Token", "TT", 18, 1000000000000000000000000);
        // mint
        token.mint(account, 1000000000000000000000000); 

        vm.stopBroadcast();
    }
}
