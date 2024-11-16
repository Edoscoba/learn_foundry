// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../interfaces/IUniswapV2Router.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract SwapTokenForExactTokenTest is Test {
    IUniswapV2Router public router;
    IERC20 public usdc;
    IERC20 public dai;
    uint256 public usdcAmountOut = 100e18;
    uint256 public daiAmountInMax = 100e18;

    function setUp() public {
        router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    }

    function testSwapTokenForExactTokens() public {
        address TOKEN_HOLDER = 0xf584F8728B874a6a5c7A8d4d387C9aae9172D621;
        uint256 deadline = block.timestamp + 60; // Add 60 seconds to current block timestamp

        // Declare the path array
        address[] memory path = new address[](2);

        vm.startPrank(TOKEN_HOLDER);
        // Approve the router to spend the token
        dai.approve(address(router), usdcAmountOut);
         usdc.approve(address(router), usdcAmountOut);

        // Populate the path array
        path[0] = address(usdc); // Output token (USDC)
        path[1] = address(dai); // Input token (DAI)

// lets log the amounts before swap
 console.log("usdc balance before liquidity", usdc.balanceOf(TOKEN_HOLDER));
  console.log("DAI balance before liquidity", dai.balanceOf(TOKEN_HOLDER));

  console.log("=========================================================");
   console.log("=========================================================");
        // Perform the swap
        router.swapTokensForExactTokens(usdcAmountOut, daiAmountInMax, path, TOKEN_HOLDER, deadline);

// lets log the amounts after swap
        console.log("usdc balance after liquidity", usdc.balanceOf(TOKEN_HOLDER));
  console.log("DAI balance after liquidity", dai.balanceOf(TOKEN_HOLDER));

  console.log("=========================================================");
   console.log("=========================================================");

        vm.stopPrank();
    }
}
