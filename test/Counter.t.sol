// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;


function setUp()  public  {

    counter = new Counter();
}

function test_Increment()   public {
    counter.increment();
    assertEq(counter.count(), 1);
    
}

function testFail_Decrement() public {
 counter.decrement();
}

// function test_DecUnderflow()public {
//     vm.expectRevert(stdError.arithmeticError);
//     counter.decrement();
// }

function test_Decrement() public {
    counter.increment();
    counter.increment();
    counter.increment();
    assertEq(counter.count(), 1);
    

}

}