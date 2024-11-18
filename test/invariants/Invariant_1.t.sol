// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {WETH} from "../../src/WETH.sol";

// NOTE: open-testing - randomly call all public functions

contract WETH_Open_Invariant_Test is Test {
    WETH public weth;

    function setUp() public {
        weth = new WETH();
    }

    function invariant_totalSupply_is_always_zero() public view {
        assertEq(weth.totalSupply(), 0);
    }

    // function testInvariant_1() public {
    //     weth.deposit{value: 1 ether}();
    //     weth.withdraw(1 ether);
    // }
}
