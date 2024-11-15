// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract MillionDaiTest is Test {
    IERC20 public dai;

    function setUp() public {
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    function testDeposit() public {
        address simonAddress = address(123);

        uint256 balBefore = dai.balanceOf(simonAddress);
        console.log("==================");
        console.log("balance before: ", balBefore);
        console.log("==================");
        /* deal() syntax
        deal(address token, address account, uint256 amount, bool isERC20);
        */
        deal(address(dai), simonAddress, 2e6 * 1e18, true);

        uint256 totalSupply = dai.totalSupply();
        console.log("==================");
        console.log("Total supply: ", totalSupply);

        console.log("==================");
        uint256 balAfter = dai.balanceOf(simonAddress);
        console.log("==================");
        console.log("balance After: ", balAfter);
        console.log("==================");
    }
}
