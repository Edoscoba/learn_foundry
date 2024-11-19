// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenFaucet {
    address public owner;
    IERC20 public token;
    uint256 public dripAmount;
    mapping(address => uint256) public lastDripTime;
    uint256 public waitTime; // Time between requests in seconds

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(address _token, uint256 _waitTime, uint256 _dripAmount) {
        owner = msg.sender;
        token = IERC20(_token);
        dripAmount = _dripAmount;
        waitTime = _waitTime;
    }

    function drip() external {
        require(block.timestamp - lastDripTime[msg.sender] >= waitTime, "Wait time not met");
        require(token.balanceOf(address(this)) >= dripAmount, "Faucet is dry");

        lastDripTime[msg.sender] = block.timestamp;
        token.transfer(msg.sender, dripAmount);
    }

    function refill(uint256 amount) external onlyOwner {
        require(token.transferFrom(msg.sender, address(this), amount), "Refill failed");
    }

    function setDripAmount(uint256 _dripAmount) external onlyOwner {
        dripAmount = _dripAmount;
    }

    function setWaitTime(uint256 _waitTime) external onlyOwner {
        waitTime = _waitTime;
    }

    function withdrawTokens(uint256 amount) external onlyOwner {
        require(token.transfer(owner, amount), "Withdraw failed");
    }
}
