// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Lending {
    struct Loan {
        uint256 amount;           // Principal loan amount
        uint256 interestRate;     // Interest rate in basis points (500 = 5%)
        uint256 dueDate;          // Loan due date
        bool repaid;              // Has the loan been repaid?
    }

    mapping(address => Loan) public loans;

    // Function to request a loan
    function requestLoan(uint256 amount) external {
        require(loans[msg.sender].amount == 0, "Loan already exists");
        require(amount > 0, "Loan amount must be greater than 0");

        // Assign the loan with a 5% interest rate and a due date of 30 days
        loans[msg.sender] = Loan(amount, 500, block.timestamp + 30 days, false);
        // Logic to issue the loan (you would transfer the loan amount here in a real use case)
    }

    // Function to calculate the interest on the loan
    function calculateInterest(address borrower) public view returns (uint256) {
        Loan storage userLoan = loans[borrower];
        require(userLoan.amount > 0, "No loan found");

        uint256 loanDuration = block.timestamp > userLoan.dueDate ? 30 days : (block.timestamp - (userLoan.dueDate - 30 days));
        uint256 interest = (userLoan.amount * userLoan.interestRate * loanDuration) / (365 days * 10000); // Annualized interest
        return interest;
    }

    // Function to repay the loan with interest
    function repayLoan() external payable {
        Loan storage userLoan = loans[msg.sender];
        require(!userLoan.repaid, "Loan already repaid");
        require(userLoan.amount > 0, "No active loan to repay");

        // Calculate the total amount to be repaid (principal + interest)
        uint256 interest = calculateInterest(msg.sender);
        uint256 totalRepayment = userLoan.amount + interest;

        // Ensure the user is sending enough Ether to cover the loan repayment
        require(msg.value >= totalRepayment, "Insufficient repayment amount");

        // Mark the loan as repaid
        userLoan.repaid = true;

        // If the user sent more than required, refund the excess amount
        if (msg.value > totalRepayment) {
            payable(msg.sender).transfer(msg.value - totalRepayment);
        }
    }

    // Function to allow the contract to receive Ether
    receive() external payable {}

    // Fallback function
    fallback() external payable {}
}
