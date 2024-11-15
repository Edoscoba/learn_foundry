// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/console.sol";
import "../interfaces/IERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GaslessTokenTransfer is ERC20, EIP712, Ownable {
    using ECDSA for bytes32;

    address public feeCollector;

    mapping(address => uint256) public nonces;

    bytes32 private constant _TRANSFER_TYPEHASH =
        keccak256("Transfer(address sender,address recipient,uint256 amount,uint256 nonce,uint256 deadline)");

    constructor(address _feeCollector)
        ERC20("GaslessToken", "GTX") // Pass name and symbol to ERC20
        EIP712("GaslessToken", "1") // Pass name and version to EIP712
        Ownable(msg.sender) // Pass initial owner to Ownable
    {
        feeCollector = _feeCollector;
        // Mint initial supply to the contract owner
        //
    }

    event GaslessTransfer(address indexed sender, address indexed receiver, uint256 amount, uint256 fee);

    function mint(address _sender, uint256 _AMOUNT) public {
        _mint(_sender, _AMOUNT * 10 ** decimals());
    }

    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount,
        uint256 fee,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // Step 1: Approve the contract to spend tokens on behalf of sender
        IERC20Permit(token).permit(sender, address(this), amount + fee, deadline, v, r, s);

        // Step 2: Perform the token transfer
        IERC20(token).transferFrom(sender, receiver, amount); // Transfer amount to receiver
        IERC20(token).transferFrom(sender, feeCollector, fee); // Transfer fee to this contract

        emit GaslessTransfer(sender, receiver, amount, fee);

        // Log the operation for debugging
        console.log("Sender balance after transfer:", IERC20(token).balanceOf(sender));
        console.log("Receiver balance after transfer:", IERC20(token).balanceOf(receiver));
        console.log("Fee Collector (contract) balance:", IERC20(token).balanceOf(address(this)));
    }

    // Function for gasless token transfer using EIP-712 signature
    function permitTransfer(address sender, address recipient, uint256 amount, uint256 deadline, bytes memory signature)
        public
    {
        require(block.timestamp <= deadline, "Signature expired");

        // Get nonce for the sender
        uint256 nonce = nonces[sender];

        // Construct the data to hash and verify signature
        bytes32 structHash = keccak256(abi.encode(_TRANSFER_TYPEHASH, sender, recipient, amount, nonce, deadline));

        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = hash.recover(signature);

        require(signer == sender, "Invalid signature");
        require(signer != address(0), "Invalid signer");

        // Increment nonce to prevent replay attacks
        nonces[sender]++;

        // Perform the transfer on behalf of the sender
        _transfer(sender, recipient, amount);
    }

    // Optional: Relayer can call this function to submit a gasless transaction on behalf of sender
    function executeGaslessTransfer(
        address sender,
        address recipient,
        uint256 amount,
        uint256 deadline,
        bytes memory signature
    ) external {
        permitTransfer(sender, recipient, amount, deadline, signature);

        // Additional logic can be added here if needed for relayers
        // Example: logging or relayer fee tracking
    }

    // Override transfer and transferFrom to prevent users from directly calling them
    function transfer(address, uint256) public pure override returns (bool) {
        revert("Direct transfers not allowed; use permitTransfer.");
    }

    function transferFrom(address, address, uint256) public pure override returns (bool) {
        revert("Direct transfers not allowed; use permitTransfer.");
    }
}
