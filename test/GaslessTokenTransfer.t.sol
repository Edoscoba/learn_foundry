// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/ERC20Permit.sol";
import "../src/GaslessTokenTransfer.sol";

contract GaslessTokenTransferTest is Test {
    ERC20Permit private token;
    GaslessTokenTransfer private gasless;

    uint256 constant SENDER_PRIVATE_KEY = 123;
    address sender;
    address receiver;

    uint256 constant AMOUNT = 1000;
    uint256 constant FEE = 10;

    // The typehash for the permit function as per EIP-2612
    bytes32 private constant _PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    function setUp() public {
        sender = vm.addr(SENDER_PRIVATE_KEY);
        receiver = address(2);

        token = new ERC20Permit();
        token.mint(sender, AMOUNT + FEE);
        console.log("mnted amount:", token.balanceOf(sender));
        gasless = new GaslessTokenTransfer(address(this));
    }

    function testValidSig() public {
        uint256 deadline = block.timestamp + 60;

        // Debug sender initial balance
        console.log("Sender initial balance:", token.balanceOf(sender));

        bytes32 PermitHash = _getPermitHash(sender, address(gasless), AMOUNT + FEE, token.nonces(sender), deadline);
        // console.log("PermitHash:", PermitHash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(SENDER_PRIVATE_KEY, PermitHash);

        // Execute send
        gasless.send(address(token), sender, receiver, AMOUNT, FEE, deadline, v, r, s);

        // Debug balances after send
        console.log("Sender balance after send:", token.balanceOf(sender));
        console.log("Receiver balance after send:", token.balanceOf(receiver));
        console.log("Fee Collector balance:", token.balanceOf(address(this)));

        uint256 initialSenderBalance = 39739872156049502951178240;
        uint256 expectedSenderBalance = initialSenderBalance - (AMOUNT + FEE);
        assertEq(token.balanceOf(sender), expectedSenderBalance, "Sender balance does not match expected balance");

        uint256 initialReceiverBalance = 0;
        uint256 expectedReceiverBalance = initialReceiverBalance + AMOUNT ;
        assertEq(token.balanceOf(receiver), expectedReceiverBalance, "Receiver balance does not match expected balance");

        uint256 initialFeeCollectorBalance = 0;
        uint256 expectedFeeCollectorBalance = initialFeeCollectorBalance + FEE;
        assertEq(
            token.balanceOf(address(this)),
            expectedFeeCollectorBalance,
            "Fee Collector balance does not match expected balance"
        );
    }

    function _getPermitHash(address owner, address spender, uint256 value, uint256 nonce, uint256 deadline)
        private
        view
        returns (bytes32)
    {
        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, nonce, deadline));

        bytes32 domainSeparator = token.DOMAIN_SEPARATOR();

        // Create the permit hash
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }
}
