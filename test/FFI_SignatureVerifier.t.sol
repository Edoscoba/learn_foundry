// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/SignatureVerifier.sol";

contract FFITest is Test {
    SignatureVerifier public verifier;

    function setUp() public {
        verifier = new SignatureVerifier();
    }

    function testRecoverSignerWithFFI() public {
        // Call the Python script using FFI
        string[] memory cmds = new string[](3);
        cmds[0] = "python3";
        cmds[1] = "generate_signature.py";

        // Execute the script and retrieve the result
        bytes memory result = vm.ffi(cmds);

        // Parse the JSON-encoded output
        (bytes memory signature, address expectedSigner) = abi.decode(result, (bytes, address));

        // Hash the message using the same method as the Python script
        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n15", "Hello, Foundry!"));

        // Recover the signer
        address signer = verifier.verify(messageHash, signature);

        // Verify that the recovered signer matches the expected signer
        assertEq(signer, expectedSigner, "Recovered signer does not match expected signer");
    }
}
