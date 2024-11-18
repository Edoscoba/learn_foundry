// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SignatureVerifier {
    using ECDSA for bytes32;

    function verify(bytes32 hash, bytes memory signature) public pure returns (address) {
        return ECDSA.recover(hash, signature);
    }
}
