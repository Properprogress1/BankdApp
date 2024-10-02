// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoperzBank {
    struct Account {
        bool exists;
        uint256 balance;
        uint256 lastInterestTimestamp;
    }

    uint256 private constant ANNUAL_INTEREST_RATE = 500;
    uint256 private constant INTEREST_INTERVAL = 365 days;

    mapping(address => Account) private accounts;
    modifier accountExists() {
        require(accounts[msg.sender].exists, "Account does not exist");
        _;
    }

    modifier hasSufficientBalance(uint256 amount) {
        require(accounts[msg.sender].balance >= amount, "Insufficient balance");
        _;
    }
    function applyInterest(address user) internal {
        Account storage account = accounts[user];
        if (block.timestamp > account.lastInterestTimestamp) {
            uint256 timeElapsed = block.timestamp - account.lastInterestTimestamp;
            if (timeElapsed >= INTEREST_INTERVAL) {
                uint256 interest = (account.balance * ANNUAL_INTEREST_RATE * timeElapsed) / (INTEREST_INTERVAL * 10000);
                account.balance += interest;
                account.lastInterestTimestamp = block.timestamp;
            }
        }
    }
    function createAccount() external {
        require(!accounts[msg.sender].exists, "Account already exists");
        accounts[msg.sender] = Account(true, 0, block.timestamp);
    }
    function deposit() external payable accountExists {
        applyInterest(msg.sender);
        accounts[msg.sender].balance += msg.value;
    }
    function withdraw(uint256 amount) external accountExists hasSufficientBalance(amount) {
        applyInterest(msg.sender);
        accounts[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
    }

    function transfer(address to, uint256 amount) external accountExists hasSufficientBalance(amount) {
        require(accounts[to].exists, "Recipient account does not exist");

        applyInterest(msg.sender);
        applyInterest(to);

        accounts[msg.sender].balance -= amount;
        accounts[to].balance += amount;
    }
    function getBalance() external view accountExists returns (uint256) {
        Account storage account = accounts[msg.sender];
        uint256 timeElapsed = block.timestamp - account.lastInterestTimestamp;
        uint256 projectedBalance = account.balance + (account.balance * ANNUAL_INTEREST_RATE * timeElapsed) / (INTEREST_INTERVAL * 10000);
        return projectedBalance;
    }
}
