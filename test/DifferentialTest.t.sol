// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {exp} from "../src/Exp.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DifferentialTest is Test {
    using Strings for uint256;

    function ffi_exp(int128 x) private returns (int128) {
        string[] memory inputs = new string[](3);
        inputs[0] = "python";
        inputs[1] = "exp.py";
        inputs[2] = uint256(int256(x)).toString();

        bytes memory res = vm.ffi(inputs);

        int128 y = abi.decode(res, (int128));
        return y;
    }

    function test_exp(int128 x) public {
        vm.assume(x >= 2 ** 64);
        vm.assume(x <= 20 * 2 ** 64);
        int128 y0 = ffi_exp(x);
        int128 y1 = exp(x);

        // check |yo - y1| <= 1 = 2**64
        uint256 DELTA = 2 ** 64;
        assertApproxEqAbs(uint256(int256(y0)), uint256(int256(y1)), DELTA);
    }
}


// To run this file use below
// FOUNDRY_FUZZ_RUNS=100 forge test --match-path test/DifferentialTest.t.sol --ffi -vvv

