// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Error {
    error NotAuthorized();

    function throwError() external pure {
        require(false, "Not Authorized");
    }

    function throwCustomError() external pure {
        revert NotAuthorized();
    }
}
