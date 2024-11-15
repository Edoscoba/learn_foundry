// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Permit is ERC20, EIP712, Ownable {
    using ECDSA for bytes32;

    mapping(address => uint256) public nonces;

    // Define the type hash following the EIP-2612 standard
    bytes32 private constant _PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    constructor()
        ERC20("GaslessToken", "GTX") // Pass name and symbol to ERC20
        EIP712("GaslessToken", "1") // Pass name and version to EIP712
        Ownable(msg.sender) // Pass initial owner to Ownable
    {}

    function mint(address _reciever, uint256 _amount) public {
        _mint(_reciever, _amount * 18 ** decimals());
    }

    function DOMAIN_SEPARATOR() public view returns (bytes32) {
        return _domainSeparatorV4();
    }

    /**
     * @notice Allows gasless approval by permitting a spender to spend on behalf of the owner using a signed message
     * @param owner Address of the token owner
     * @param spender Address authorized to spend the tokens
     * @param value The amount of tokens to allow
     * @param deadline Expiration time for the permit in seconds since the epoch
     * @param v The recovery byte of the signature
     * @param r The first 32 bytes of the signature
     * @param s The second 32 bytes of the signature
     */
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external
    {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        uint256 nonce = nonces[owner];
        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, nonce, deadline));

        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = hash.recover(v, r, s);

        require(signer == owner, "ERC20Permit: invalid signature");
        require(signer != address(0), "ERC20Permit: invalid signer");

        // Increment the owner's nonce to prevent replays
        nonces[owner]++;

        // Approve the spender to spend on behalf of the owner
        _approve(owner, spender, value);
    }
}
