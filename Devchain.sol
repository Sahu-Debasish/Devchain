// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeFiLending {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;
    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        balances[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function transfer(address to, uint256 amount) external {
        require(to != address(0), "Invalid recipient address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(to != address(0), "Invalid recipient address");
        require(balances[from] >= amount, "Insufficient balance");
        require(allowed[from][msg.sender] >= amount, "Allowance exceeded");

        balances[from] -= amount;
        balances[to] += amount;
        allowed[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }
}
