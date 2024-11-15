// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

interface IWETH {
    function deposit() external payable;
    function balanceOf(address account) external view returns (uint256);
}

contract ForkTest is Test {
  IWETH public weth;

  function setUp() public {
    weth = IWETH(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2));
}

    
  function testDeposit() public {
    // Check Ether balance before anything else
    console.log("Ether balance of test contract before:", address(this).balance);

    // Optionally fund the contract
    deal(address(this), 2 ether);

    uint256 balBefore = weth.balanceOf(address(this));
    console.log("==================");
     console.log("Ether balance of test contract before deposit:", address(this).balance);
    console.log("WETH balance before deposit:", balBefore);
console.log("==================");
    weth.deposit{value: 1 ether}();

    uint256 balAfter = weth.balanceOf(address(this));
    console.log("WETH balance after deposit:", balAfter);

    // Check Ether balance after deposit
    console.log("Ether balance of test contract after:", address(this).balance);

    assertEq(balAfter, balBefore + 1 ether, "Deposit failed!");
}


}