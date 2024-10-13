// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library DaoObjects {
    struct Proposal {
        uint256 id;
        bytes description;
        address proposalCreator;
        bool isExecuted;
        uint128 createdOn;
        uint256 deadline;
    }

    struct ProposalDTO {
        bytes description;
        address creator;
    }
    enum ProposalType {
        NIL, 
        DISPUTE, 
        DURATION
    }
}
