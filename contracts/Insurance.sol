// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Insurance {
    struct InsurancePolicy {
        uint256 amountInsured;
        uint256 premium;
        bool isActive;
    }

    mapping(address => InsurancePolicy) public policies;

    // Function to purchase insurance
    function purchaseInsurance(uint256 amount) external payable {
        require(msg.value >= calculatePremium(amount), "Insufficient premium");
        require(amount > 0, "Insured amount must be greater than 0");

        // Assign the insurance policy to the user
        policies[msg.sender] = InsurancePolicy(amount, msg.value, true);
    }

    // Function to calculate the premium (1% of the insured amount)
    function calculatePremium(uint256 amount) public pure returns (uint256) {
        return (amount * 1) / 100; // 1% premium
    }

    // Function to claim insurance
    function claimInsurance() external {
        InsurancePolicy storage policy = policies[msg.sender];
        require(policy.isActive, "No active insurance policy");
        require(policy.amountInsured > 0, "No amount insured");

        // Transfer the insured amount to the policyholder
        payable(msg.sender).transfer(policy.amountInsured);

        // Mark the policy as inactive to prevent further claims
        policy.isActive = false;
    }

    // Function to allow the contract to receive Ether
    receive() external payable {}

    // Fallback function in case Ether is sent to the contract without data
    fallback() external payable {}
}
