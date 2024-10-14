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
        uint256 forProposal;
        uint256 againstProposal;
    }

    struct ProposalDTO {
        bytes description;
        address creator;
    }

    enum ProposalType {
        NIL,
        DISPUTE,
        DURATION,
        QUORUM,
        DAO
    }

      enum ProposalState {
        Pending,
        Active,
        Canceled,
        Defeated,
        Succeeded,
        Queued,
        Expired,
        Executed
    }
}
