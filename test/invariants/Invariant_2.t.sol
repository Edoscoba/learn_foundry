// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

// import Test.sol and console.sol
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {WETH} from "../../src/WETH.sol";

// Topics
// - handler based testing -> test functions under specific conditions
// - target contract
// -target selector

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
    WETH private weth;
    uint256 public wethBalance;
    uint256 public numCalls;

    constructor(WETH _weth) {
        weth = _weth;
    }

    receive() external payable {}

    function sendToFallback(uint256 amount) external {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        numCalls += 1;

        (bool sucess,) = address(weth).call{value: amount}("");
        require(sucess, "call failed");
    }

    function deposit(uint256 amount) external payable {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        numCalls += 1;
        weth.deposit{value: amount}();
    }

    function withdraw(uint256 amount) public {
        amount = bound(amount, 0, weth.balanceOf(address(this)));
        wethBalance -= amount;
        numCalls += 1;
        weth.withdraw(amount);
    }

    function fail() public pure {
        revert("failed"); // this will fail the test
    }
}

contract WETH_Handler_Based_Invariant_Test is Test {
    WETH public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH();
        handler = new Handler(weth);
        deal(address(handler), 100 * 1e18);
        targetContract(address(handler));
        bytes4[] memory selectors = new bytes4[](3);
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.sendToFallback.selector;
        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    function invariant_eth_balance() public view {
        console.log("WETH Contract Balance:", address(weth).balance);
        console.log("Handler WETH Balance:", handler.wethBalance());
        assertGe(address(weth).balance, handler.wethBalance());
        // Check that the contract's ETH balance matches the handler's recorded balance
        assertEq(address(weth).balance, handler.wethBalance());
    }
}
