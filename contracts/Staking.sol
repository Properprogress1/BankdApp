// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Staking {
    struct Stake {
        uint256 amount;         // Amount staked by the user
        uint256 unlockTime;     // Time after which the stake can be withdrawn
        uint256 rewardRate;     // Annual reward rate in basis points (800 = 8%)
    }

    mapping(address => Stake) public stakes;
    uint256 private constant LOCK_PERIOD = 30 days;

   
    function stake(uint256 amount) external {
        require(amount > 0, "Invalid stake amount");

        stakes[msg.sender] = Stake(amount, block.timestamp + LOCK_PERIOD, 800); // 8% annual reward rate
    }

    
    function withdrawStake() external {
        Stake storage userStake = stakes[msg.sender];
        require(block.timestamp >= userStake.unlockTime, "Stake still locked");
        require(userStake.amount > 0, "No active stake found");

        uint256 interest = calculateInterest(msg.sender); //Calculate the interest earned based on the staked amount and reward rate

      
        uint256 totalWithdrawal = userStake.amount + interest;   // Calculate the total amount to withdraw (principal + interest)

        userStake.amount = 0;

       
        payable(msg.sender).transfer(totalWithdrawal);  // Transfer the total amount (principal + interest) to the user
    }
    function calculateInterest(address user) public view returns (uint256) {
        Stake storage userStake = stakes[user];
        uint256 stakedAmount = userStake.amount;
        uint256 rewardRate = userStake.rewardRate;

        
        uint256 interest = (stakedAmount * rewardRate * LOCK_PERIOD) / (365 days * 10000);
        return interest;
    }

    receive() external payable {}

    fallback() external payable {}
}
