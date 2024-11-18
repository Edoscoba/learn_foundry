// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../interfaces/IUniswapV2Router.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract SwapTokenForExactTokenTest is Test {
    IUniswapV2Router public router;
    IERC20 public dai;
    IERC20 public usdc;

    function setUp() public {
        // 初始化合约实例
        router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    }

    function testSwapTokenForExactToken() public {
        address TOKEN_HOLDER = 0xf584F8728B874a6a5c7A8d4d387C9aae9172D621;
        uint256 deadline = block.timestamp + 60; // Add 60 seconds to current block timestamp
        uint256 usdcAmountOut = 100e6;
        uint256 daiAmountInMax = 150e18;
        address[] memory path = new address[](2);
        path[0] = address(dai);
        path[1] = address(usdc);

        // 获取交换前的余额
        vm.startPrank(TOKEN_HOLDER);
        uint256 daiBalanceBefore = dai.balanceOf(TOKEN_HOLDER);
        uint256 usdcBalanceBefore = usdc.balanceOf(TOKEN_HOLDER);

        // 打印交换前的余额
        console.log("DAI balance before swap:", daiBalanceBefore);
        console.log("USDC balance before swap:", usdcBalanceBefore);
        console.log("=========================================================");
        console.log("=========================================================");
        // Approve the router to spend the token
        dai.approve(address(router), daiAmountInMax);

        // Perform the swap
        router.swapTokensForExactTokens(usdcAmountOut, daiAmountInMax, path, TOKEN_HOLDER, deadline);

        // 获取交换后的余额
        uint256 daiBalanceAfter = dai.balanceOf(TOKEN_HOLDER);
        uint256 usdcBalanceAfter = usdc.balanceOf(TOKEN_HOLDER);

        // 打印交换后的余额
        console.log("DAI balance after swap:", daiBalanceAfter);
        console.log("USDC balance after swap:", usdcBalanceAfter);
    }
}
