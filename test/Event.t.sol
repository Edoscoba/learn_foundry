// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Event} from "../src/Event.sol";

contract EventTest is Test {
    Event public e;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        e = new Event();
    }

    function testEmitTransferEvent() public {
        uint256 amount = 456;
        address reciever = address(123);

        // function expectEmit(bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkDta) exter nal

        // tell foundry which data to check
        // check index 1, index 2, and data
        vm.expectEmit(true, true, false, true);

        // 2 Emit the expected event
        emit Transfer(address(this), reciever, amount);

        // 3 call the function that should emit the event
        e.transfer(address(this), reciever, amount);

        // check index 1
        vm.expectEmit(true, false, false, false);

        //  2 emit the expect event
        emit Transfer(address(this), reciever, amount);

        // 3 call the function that should emit the event
        e.transfer(address(this), address(777), 999);
    }

    function testEmitTransferAnyEvent() public {
      address[] memory to = new address[](2); 
      to[0]= address(123);
      to[1]= address(456);

      uint256[] memory amounts = new uint256[](2);
      amounts[0]= 777;
      amounts[1]= 888;

      for (uint i = 0; i < to.length; i++) {
       // tell foundry which data to check
        // 2 Emit the expected event
          vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), to[i], amounts[i]);
      }
        // 3 call the function that should emit the event
        e.transferForMany(address(this),to, amounts);


       


         
    }
}
