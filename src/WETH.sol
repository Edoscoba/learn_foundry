//  write a WETH ETH contract  that when i deposit eth i get weth and when i deposit weth i get back eth

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract WETH {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed sender, uint256 amount);
    event Withdraw(address indexed sender, uint256 amount);

    mapping(address => uint256) public balanceOf;
    // mapping for allowance
    mapping(address => mapping(address => uint256)) public allowance;

    uint256 public totalSupply;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
    // transferFrom function

    function transferFrom(address src, address dst, uint256 wad) external returns (bool) {
        require(balanceOf[src] >= wad, "Insufficient balance");
        require(allowance[src][msg.sender] >= wad, "Insufficient allowance");
        balanceOf[src] -= wad;
        balanceOf[dst] += wad;
        allowance[src][msg.sender] -= wad;
        emit Transfer(src, dst, wad);
        return true;
    }

    function transfer(address dst, uint256 wad) external returns (bool) {
        require(balanceOf[msg.sender] >= wad, "Insufficient balance");
        balanceOf[msg.sender] -= wad;
        balanceOf[dst] += wad;
        emit Transfer(msg.sender, dst, wad);
        return true;
    }

    function approve(address guy, uint256 wad) external returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }
    // function to check the  balance of the contract

    function totalbal() external view returns (uint256) {
        return address(this).balance;
    }
}

// for
