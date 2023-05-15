//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract EtherBank {
    mapping (address => uint256) private balances;
    
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);


    address payable public owner;
    uint256 public depositAmount;

    // Event to notify when initial deposit is made
    event InitialDeposit(address indexed _from, uint256 _amount);
    // Constructor
    constructor() payable {
        owner = payable(msg.sender);
        depositAmount = msg.value;

        emit InitialDeposit(msg.sender, msg.value);
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero.");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdrawal amount must be greater than zero.");
        require(balances[msg.sender] >= amount, "Insufficient balance.");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
