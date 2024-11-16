// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Bit} from "../src/Bit.sol";

// topics
// fuzz
// assume and bound
// stats
contract FuzzTest is Test {
    Bit public b;

    function setUp() public {
        b = new Bit();
    }

    function mostSignificantBit(uint256 x) public pure returns (uint256) {
        uint256 i = 0;
        while ((x >>= 1) > 0) {
            i++;
        }
        return i;
    }

    function testMostSignificantBitManual() public view {
        assertEq(b.mostSignificantBit(0), 0);
        assertEq(b.mostSignificantBit(1), 0);
        assertEq(b.mostSignificantBit(2), 1);
        assertEq(b.mostSignificantBit(4), 2);
        assertEq(b.mostSignificantBit(8), 3);
        assertEq(b.mostSignificantBit(type(uint256).max), 255);
    }

    function testMostSignificantBitFuzz(uint256 x) public view {
        // assume -> If false, the fuzzer will discard the current fuzz inputs
        // and start a new fuzz run with different inputs.
        // skip x = 0
        // vm.assume(x > 0);
        // assertGt(x,0);
        // bound(input,min,max) -> bound input between min and max
        x = bound(x, 1, 10);
        console.log("the number is:", x);
        assertGe(x, 1);
        assertLe(x, 10); // Assert x <= 10


        uint256 i = b.mostSignificantBit(x);
        assertEq(i, mostSignificantBit(x));
    }

    function testStats(uint256 x) public {
    x = bound(x, 1, 10); // Restrict x to [1, 10]
    console.log("Input: ", x);

    // Collect stats
    emit log_named_uint("Input Distribution", x);
}

}
