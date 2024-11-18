// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.19;

import {Test, console} from "forge-std/Test.sol";


contract FFITest is Test {
      
    function testFFI() public {
      string[] memory cmds = new string[](2);
      cmds[0] = "cat";
      cmds[1]= "ffi_test.txt";
      bytes memory res = vm.ffi(cmds);
      console.log(string(res));

    }
}
