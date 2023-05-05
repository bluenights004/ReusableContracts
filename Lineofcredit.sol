// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLineOfCredit {
    /// @notice - positions ids of all open credit lines.
    /// @dev    - may contain null elements
    bytes32[] public ids;

    /// @notice id -> position data
    mapping(bytes32 => Credit) public credits;

    struct Credit {
        bool isOpen;
        uint256 principal;
        uint256 interestAccrued;
    }

    event NewCreditLine(bytes32 indexed id, uint256 principal);

    function createCreditLine(uint256 principal) external {
        bytes32 id = keccak256(abi.encodePacked(msg.sender, block.timestamp));

        ids.push(id);

        credits[id] = Credit({
            isOpen: true,
            principal: principal,
            interestAccrued: 0
        });

        emit NewCreditLine(id, principal);
    }

    function closeCreditLine(bytes32 id) external {
        Credit storage credit = credits[id];

        require(credit.isOpen, "Credit line is already closed");
        require(credit.principal == 0, "Cannot close credit line with outstanding principal");

        credit.isOpen = false;

        // Remove the closed credit line from the ids array
        for (uint256 i = 0; i < ids.length; i++) {
            if (ids[i] == id) {
                ids[i] = ids[ids.length - 1];
                ids.pop();
                break;
            }
        }
    }

    function repay(bytes32 id, uint256 amount) external {
        Credit storage credit = credits[id];

        require(credit.isOpen, "Credit line is closed");
        require(credit.principal >= amount, "Repayment amount exceeds outstanding principal");

        credit.principal -= amount;
    }

    function accrueInterest(bytes32 id, uint256 interest) external {
        Credit storage credit = credits[id];

        require(credit.isOpen, "Credit line is closed");

        credit.interestAccrued += interest;
    }
}
